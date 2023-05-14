//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import Foundation

public struct TransactionID: Codable {
    public let lt: Int64
    public let hash: Data
}

public struct Transaction {
    public let id: TransactionID
    public let sender: Address
    public let receiver: Address
    public let amount: Nanogram
    public let fee: Nanogram
    public let date: Date
    public let message: String?
    public var isIncome: Bool
}
