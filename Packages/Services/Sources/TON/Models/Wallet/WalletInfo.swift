//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation

public struct WalletInfo: Codable, Hashable {
    public let uuid: UUID
    public let type: WalletType
    public let walletID: Int
    public let address: Address
    public let credentials: Credentials

    public init(
        uuid: UUID,
        type: WalletType,
        walletID: Int,
        address: Address,
        credentials: Credentials
    ) {
        self.uuid = uuid
        self.type = type
        self.walletID = walletID
        self.address = address
        self.credentials = credentials
    }

    public struct Credentials: Codable, Equatable {
        public let privateKey: Data
        public let secretKey: Data
        public let publicKey: PublicKey
        public let mnemonicWords: [String]
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
