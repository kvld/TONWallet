//
//  Created by Vladislav Kiriukhin on 22.04.2023.
//

import Foundation
import Security
import CommonCrypto
import CryptoKit
import Sodium

public struct MnemonicGeneratorError: Error {
    let message: String
}

public struct PrivateKey {
    public let data: Data

    public var publicKey: Data {
        get throws {
            try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: data).publicKey.rawRepresentation
        }
    }
}

public struct MnemonicGenerator {
    /// PBKD rounds count
    public let pbkdRoundsCount: UInt

    /// Words count
    public let wordsCount: UInt

    /// Words list
    public let wordsList: [String]

    public init(
        pbkdRoundsCount: UInt = 100_000,
        wordsCount: UInt = 24,
        wordsList: [String] = MnemonicWords.english
    ) throws {
        if wordsList.count != 2048 {
            throw MnemonicGeneratorError(message: "bip39 words list should be exactly 2048 words")
        }

        if wordsCount < 8 || wordsCount > 48 {
            throw MnemonicGeneratorError(message: "Invalid words count, should be 8...48")
        }

        self.pbkdRoundsCount = pbkdRoundsCount
        self.wordsCount = wordsCount
        self.wordsList = wordsList
    }

    public func generateSeed(from mnemonicWords: [String], password: String = "") async throws -> Data {
        let salt = "TON default seed".data(using: .utf8) ?? {
            assertionFailure("Invalid password salt")
            return Data()
        }()

        guard let mnemonicPhrase = mnemonicWords.joined(separator: " ").data(using: .utf8) else {
            throw MnemonicGeneratorError(message: "Invalid mnemonic phrase")
        }

        guard let passwordData = password.data(using: .utf8) else {
            throw MnemonicGeneratorError(message: "Invalid password")
        }

        let generationTask = Task {
            let entropy = Self.generateEntropy(from: mnemonicPhrase, password: passwordData)

            guard let key = Self.computePBKD(from: entropy, salt: salt, roundsCount: UInt32(pbkdRoundsCount)) else {
                throw MnemonicGeneratorError(message: "Error while generating key")
            }

            return key.prefix(32)
        }

        return try await generationTask.value
    }

    public func generateKeyPair(from seed: Data) async throws -> (publicKey: PrivateKey, secretKey: Data) {
        return try await Task {
            guard let keyPair = Sodium().sign.keyPair(seed: Array(seed)) else {
                throw MnemonicGeneratorError(message: "Invalid key pair generation")
            }

            return (PrivateKey(data: Data(keyPair.publicKey)), Data(keyPair.secretKey))
        }
        .value
    }

    public func generateMnemonic(password: String = "") async throws -> [String] {
        let hasPassword = !password.isEmpty

        let generationTask = Task {
            while true {
                try Task.checkCancellation()

                let words = try (0..<wordsCount).map { _ in
                    guard let randomInt = try? UInt.generateSecureRandom() else {
                        throw MnemonicGeneratorError(message: "Invalid secure number generation")
                    }

                    return wordsList[Int(randomInt % UInt(wordsList.count))]
                }

                guard let mnemonicPhrase = words.joined(separator: " ").data(using: .utf8) else {
                    throw MnemonicGeneratorError(message: "Invalid mnemonic phrase")
                }

                if hasPassword {
                    let nonPasswordEntropy = Self.generateEntropy(from: mnemonicPhrase)
                    let isBasicSeed = try checkIfIsBasicSeed(entropy: nonPasswordEntropy)
                    let isPasswordSeed = try checkIfIsPasswordSeed(entropy: nonPasswordEntropy)

                    if !isPasswordSeed || isBasicSeed {
                        continue
                    }
                }

                guard let passwordData = password.data(using: .utf8) else {
                    throw MnemonicGeneratorError(message: "Invalid password")
                }

                let passwordEntropy = Self.generateEntropy(from: mnemonicPhrase, password: passwordData)
                let isBasicSeed = try checkIfIsBasicSeed(entropy: passwordEntropy)
                if !isBasicSeed {
                    continue
                }

                return words
            }
        }

        return try await generationTask.value
    }

    // MARK: - Private

    private static func generateEntropy(from data: Data, password: Data = .init()) -> Data {
        let message = HMAC<SHA512>.authenticationCode(for: data, using: SymmetricKey(data: password))
        return Data(message)
    }

    private func checkIfIsPasswordSeed(entropy: Data) throws -> Bool {
        let salt = "TON fast seed version".data(using: .utf8) ?? {
            assertionFailure("Invalid password salt")
            return Data()
        }()

        guard let key = Self.computePBKD(from: entropy, salt: salt, roundsCount: 1) else {
            throw MnemonicGeneratorError(message: "Invalid pbkd derived key")
        }

        return key.first == 0x1
    }

    private func checkIfIsBasicSeed(entropy: Data) throws -> Bool {
        let salt = "TON seed version".data(using: .utf8) ?? {
            assertionFailure("Invalid password salt")
            return Data()
        }()

        guard let key = Self.computePBKD(from: entropy, salt: salt, roundsCount: UInt32(pbkdRoundsCount / 256)) else {
            throw MnemonicGeneratorError(message: "Invalid pbkd derived key")
        }

        return key.first == 0x0
    }

    private static func computePBKD(from data: Data, salt: Data, roundsCount: UInt32) -> Data? {
        let derivedKeySize = 512
        var derivedKeyData = Data(repeating: 0, count: derivedKeySize)

        let status = derivedKeyData.withUnsafeMutableBytes { (derivedKeyBytes: UnsafeMutableRawBufferPointer) in
            return data.withUnsafeBytes { (dataBuffer: UnsafeRawBufferPointer) in
                return salt.withUnsafeBytes { (saltBuffer: UnsafeRawBufferPointer) in
                    let dataPointer = dataBuffer.bindMemory(to: CChar.self).baseAddress
                    let saltPointer = saltBuffer.bindMemory(to: UInt8.self).baseAddress
                    let derivedKeyPointer = derivedKeyBytes.bindMemory(to: UInt8.self).baseAddress

                    return CCKeyDerivationPBKDF(
                        CCPBKDFAlgorithm(kCCPBKDF2),
                        dataPointer,
                        data.count,
                        saltPointer,
                        salt.count,
                        CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512),
                        roundsCount,
                        derivedKeyPointer,
                        derivedKeySize
                    )
                }
            }
        }

        return status == kCCSuccess ? derivedKeyData : nil
    }
}

extension Data {
    fileprivate static func generateSecureRandomBytes(count: Int) -> Data? {
        var bytes = Data(repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
        return status == errSecSuccess ? bytes : nil
    }
}

extension UInt {
    fileprivate static func generateSecureRandom() throws -> UInt? {
        let count = MemoryLayout<UInt>.size
        var bytes = Data(repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)

        if status == errSecSuccess {
            return bytes.withUnsafeBytes { pointer in
                return pointer.load(as: UInt.self)
            }
        }

        return nil
    }
}
