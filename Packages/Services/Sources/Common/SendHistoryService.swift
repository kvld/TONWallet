//
//  Created by Vladislav Kiriukhin on 27.05.2023.
//

import Foundation
import TON
import Storage

public struct SendHistoryEntry: Codable {
    public let address: Address
    public let domain: String?
    public let date: Date

    public init(address: Address, domain: String? = nil, date: Date) {
        self.address = address
        self.domain = domain
        self.date = date
    }
}

public final class SendHistoryService {
    private let storage: Storage

    public init(storage: Storage) {
        self.storage = storage
    }

    public func getHistory() -> [SendHistoryEntry] {
        ((try? storage.retrieve(with: .sendHistory, type: .unsafe)) ?? [SendHistoryEntry]()).reversed()
    }

    public func add(entry: SendHistoryEntry) {
        let history = ((try? storage.retrieve(with: .sendHistory, type: .unsafe)) ?? [SendHistoryEntry]()) + [entry]
        try? storage.store(history, withKey: .sendHistory)
    }

    public func clear() {
        storage.remove(with: .sendHistory)
    }
}

extension StorageKey {
    fileprivate static var sendHistory: StorageKey { .init("sendHistory") }
}
