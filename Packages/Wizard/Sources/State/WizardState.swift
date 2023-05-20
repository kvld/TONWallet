//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import Combine
import TON
import CommonServices

public struct WizardState {
    internal(set) public var mnemonicShowDate: Date?
    internal(set) public var mnemonicGoToTestAttempts: Int
    internal(set) public var mnemonicTestWordsIndices: [Int]
    internal(set) public var passcode: String?
    internal(set) public var walletInfo: WalletInfo?
    internal(set) public var supportedBiometricType: BiometricType?
    internal(set) public var isBiometricEnabled: Bool

    public var mnemonicWords: [String] {
        walletInfo?.credentials.mnemonicWords ?? []
    }

    public enum BiometricType {
        case touchID
        case faceID
    }

    static var initial: WizardState = .init(
        mnemonicGoToTestAttempts: 0,
        mnemonicTestWordsIndices: [],
        isBiometricEnabled: false
    )
}

@MainActor
public protocol WizardViewModelOutput: AnyObject {
    func showCongratulations()
    func showMnemonicWordsList()
    func showMnemonicWordsTooFastAlert(canSkip: Bool)
    func showMnemonicWordsTest()
    func showPasscodeSetUp()
    func showFailedTestAlert()
    func showPasscodeConfirmation()
    func showBiometric()
    func showFinal()
    func showImport()
    func showImportSomeWordsEmptyAlert()
    func showImportWrongWordAlert()
}

public final class WizardViewModel: ObservableObject {
    private let tonService: TONService
    private let configService: ConfigService
    private let biometricService: BiometricService

    @Published public var state: WizardState

    public weak var output: WizardViewModelOutput?

    public init(tonService: TONService, configService: ConfigService, biometricService: BiometricService) {
        self.tonService = tonService
        self.state = .initial
        self.configService = configService
        self.biometricService = biometricService
    }
}

extension WizardViewModel {
    public func generateMnemonic() {
        Task {
            do {
                let walletInfo = try await tonService.createWallet()

                await MainActor.run {
                    state.walletInfo = walletInfo
                }

                await output?.showCongratulations()
            } catch {
                // TODO: error
            }
        }
    }

    @MainActor
    public func startTimerToSaveMnemonic() {
        state.mnemonicShowDate = state.mnemonicShowDate ?? Date()
    }

    @MainActor
    public func proceedToSavedMnemonicTest() {
        let mnemonicShowDate = state.mnemonicShowDate ?? Date(timeIntervalSinceReferenceDate: 0.0)
        let thresholdInterval: TimeInterval = 30.0

        generateMnemonicTestIndices()

        if -mnemonicShowDate.timeIntervalSince(Date()) >= thresholdInterval {
            output?.showMnemonicWordsTest()
        } else {
            let canSkip = state.mnemonicGoToTestAttempts > 0
            output?.showMnemonicWordsTooFastAlert(canSkip: canSkip)
        }

        state.mnemonicGoToTestAttempts += 1
    }

    @MainActor
    public func checkMnemonicTestWords(allWords: [String]) {
        let words = zip(allWords, state.mnemonicWords).enumerated().map { (idx, pair) in
            if !state.mnemonicTestWordsIndices.contains(idx) {
                return true
            }

            let isEqual = pair.0.lowercased() == pair.1

            #if DEBUG
            return isEqual || pair.0 == "a"
            #else
            return isEqual
            #endif
        }

        if words.allSatisfy({ $0 }) {
            output?.showPasscodeSetUp()
        } else {
            output?.showFailedTestAlert()
        }
    }

    @MainActor
    public func setUpPasscode(_ value: String) {
        state.passcode = value
        output?.showPasscodeConfirmation()
    }

    @MainActor
    public func confirmPasscode(_ value: String) -> Bool {
        let currentPasscode = state.passcode

        if value == currentPasscode {
            if !biometricService.isSupportBiometric {
                try! completeWizard()
            } else {
                state.supportedBiometricType = biometricService.isSupportFaceID ? .faceID : .touchID
                output?.showBiometric()
            }

            return true
        } else {
            return false
        }
    }

    @MainActor
    public func importMnemonic() {
        state.mnemonicTestWordsIndices = (0..<24).map { $0 }

        output?.showImport()
    }

    public func getMnemonicSuggestions(prefix: String) async -> [String] {
        let words = (try? await tonService.getMnemonicSuggestions(prefix: prefix)) ?? []
        return Array(words.prefix(3))
    }

    @MainActor
    public func checkMnemonicImport(allWords: [String]) async {
        let possibleWords = Set((try? await tonService.getMnemonicSuggestions(prefix: "")) ?? [])

        if possibleWords.isEmpty {
            return
        }

        let allWords = allWords.map { $0.lowercased() }

        for word in allWords {
            if word.isEmpty {
                output?.showImportSomeWordsEmptyAlert()
                return
            }

            if !possibleWords.contains(word) {
                output?.showImportWrongWordAlert()
            }
        }

        do {
            let walletInfo = try await tonService.importWallet(mnemonicWords: allWords)
            state.walletInfo = walletInfo

            output?.showPasscodeSetUp()
        } catch {
            // TODO:
        }
    }

    @MainActor
    public func tryToEnableBiometric() async {
        let result = await biometricService
            .evaluate(withLocalizedReason: "TON Wallet uses biometric authentication to authorize transactions.")

        state.isBiometricEnabled = result
        try? completeWizard()
    }

    @MainActor
    public func skipBiometric() {
        try? completeWizard()
    }

    // MARK: - Private

    @MainActor
    private func generateMnemonicTestIndices() {
        let testWordsCount = 3
        var indices: Set<Int> = .init()

        while indices.count < testWordsCount {
            let newIndex = Int.random(in: 0..<state.mnemonicWords.count)
            indices.insert(newIndex)
        }

        state.mnemonicTestWordsIndices = Array(indices).sorted()
    }

    @MainActor
    private func completeWizard() throws {
        guard let walletInfo = state.walletInfo, let passcode = state.passcode else {
            assertionFailure("Inconsistent state: wallet and passcode info should be in the state")
            return
        }

        let resultWalletInfo = walletInfo.copyWithLocalAuthenticationOptions(
            passcode: passcode,
            isBiometricEnabled: state.isBiometricEnabled
        )

        try configService.updateWallet(with: resultWalletInfo)
        output?.showFinal()
    }
}
