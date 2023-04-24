//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import BOC

enum WalletFactory {
    static func makeWallet(
        type: WalletType = .default,
        workchain: Int,
        defaultWalletID: Int,
        publicKey: Data
    ) -> any Wallet {
        switch type {
        case .v3r1:
            return WalletV3R1(workchain: workchain, defaultWalletID: defaultWalletID, publicKey: publicKey)
        case .v3r2:
            return WalletV3R2(workchain: workchain, defaultWalletID: defaultWalletID, publicKey: publicKey)
        case .v4r2:
            return WalletV4R2(workchain: workchain, defaultWalletID: defaultWalletID, publicKey: publicKey)
        }
    }
}
