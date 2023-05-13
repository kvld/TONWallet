//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation

public struct WalletInfo: Codable {
    public let uuid: UUID
    public let type: WalletType
    public let walletID: Int
    public let address: Address
    public let keys: Keys

    public init(
        uuid: UUID,
        type: WalletType = .default,
        walletID: Int,
        address: Address,
        keys: Keys
    ) {
        self.uuid = uuid
        self.type = type
        self.walletID = walletID
        self.address = address
        self.keys = keys
    }

    public struct Keys: Codable {
        public let privateKey: Data
        public let secretKey: Data
        public let publicKey: PublicKey
        public let mnemonicWords: [String]
    }
}
