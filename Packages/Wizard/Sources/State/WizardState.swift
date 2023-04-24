//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import Combine
import TON

public struct WizardState {
    internal(set) public var mnemonicShowDate: Date?
    internal(set) public var mnemonicGoToTestAttempts: Int
    internal(set) public var mnemonicTestWordsIndices: [Int]
    internal(set) public var passcode: String?
    internal(set) public var walletInfo: WalletInfo?

    public var mnemonicWords: [String] {
        walletInfo?.keys.mnemonicWords ?? []
    }

    static var initial: WizardState = .init(
        mnemonicGoToTestAttempts: 0,
        mnemonicTestWordsIndices: []
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
}

public final class WizardViewModel: ObservableObject {
    private let tonService: TONService
    private let walletStateService: WalletStateService

    @Published public var state: WizardState

    public weak var output: WizardViewModelOutput?

    public init(tonService: TONService, walletStateService: WalletStateService) {
        self.tonService = tonService
        self.state = .initial
        self.walletStateService = walletStateService
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
            guard let walletInfo = state.walletInfo else {
                assertionFailure("Inconsistent state: wallet info should be in the state")
                return false
            }

            try! walletStateService.updateWallet(with: walletInfo)
            output?.showFinal()

            return true
        } else {
            return false
        }
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
}
