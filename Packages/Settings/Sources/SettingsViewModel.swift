//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import SwiftUI
import TON
import CommonServices

final class SettingsViewModel: ObservableObject {
    private let configService: ConfigService
    private let tonService: TONService
    private let biometricService: BiometricService

    @Published var wallets: [WalletType]
    @Published var biometricType: BiometricType?
    @Published var isBiometricEnabled: Bool = false {
        didSet {
            updateBiometricState()
        }
    }

    weak var output: SettingsModuleOutput?

    init(configService: ConfigService, tonService: TONService, biometricService: BiometricService) {
        self.configService = configService
        self.tonService = tonService
        self.biometricService = biometricService

        if biometricService.isSupportBiometric {
            self.biometricType = biometricService.isSupportFaceID ? .faceID : .touchID
            self.isBiometricEnabled = configService.config.value.securityConfirmation.isBiometricEnabled
        }

        self.wallets = TON.WalletType.allCases.map { type in
            let title: String = {
                switch type {
                case .v3r1: return "v3R1"
                case .v3r2: return "v3R2"
                case .v4r2: return "v4R2"
                }
            }()

            return WalletType(
                id: type.rawValue,
                title: title,
                isActive: configService.config.value.lastUsedWallet?.type == type
            )
        }
    }

    func switchWallet(to walletID: String) async {
        guard let walletType = TON.WalletType(rawValue: walletID) else {
            return
        }

        guard let activeWalletInfo = configService.config.value.lastUsedWallet,
              activeWalletInfo.type != walletType else {
            return
        }

        if let walletInfo = configService.getWallet(with: walletType) {
            configService.updateWallet(with: walletInfo)
        } else {
            guard let newWalletInfo = try? await tonService.importWallet(
                mnemonicWords: activeWalletInfo.credentials.mnemonicWords,
                walletType: walletType
            ) else {
                return
            }

            configService.updateWallet(with: newWalletInfo)
        }
    }

    @MainActor
    func showMnemonicWords() async {
        guard let credentials = configService.config.value.lastUsedWallet?.credentials else {
            return
        }

        await showPasscodeConfirmationAndPerformAction { [weak output] in
            output?.showMnemonicWords(words: credentials.mnemonicWords)
        }
    }

    @MainActor
    func changePasscode() async {
        await showPasscodeConfirmationAndPerformAction { [weak output, weak configService] in
            output?.showPasscodeChange { newPasscode in
                guard let configService else {
                    return
                }

                configService.updateSecurityInformation(passcode: newPasscode)
            }
        }
    }

    @MainActor
    func deleteAccount() {
        output?.showDeleteConfirmation { [weak configService] in
            guard let configService else {
                return
            }

            configService.removeAllData()
        }
    }

    // MARK: - Private

    private func updateBiometricState() {
        configService.updateSecurityInformation(isBiometricEnabled: isBiometricEnabled)
    }

    @MainActor
    private func showPasscodeConfirmationAndPerformAction(_ action: @escaping () -> Void) async {
        let credentials = configService.config.value.securityConfirmation

        if biometricService.isSupportBiometric, credentials.isBiometricEnabled {
            let result = await biometricService.evaluate()
            if !result {
                output?.showPasscodeConfirmation(passcode: credentials.passcode, onSuccess: action)
            } else {
                action()
            }
        } else {
            output?.showPasscodeConfirmation(passcode: credentials.passcode, onSuccess: action)
        }
    }
}

extension SettingsViewModel {
    struct WalletType: Identifiable {
        let id: String
        let title: String
        let isActive: Bool
    }

    enum BiometricType {
        case faceID
        case touchID
    }
}
