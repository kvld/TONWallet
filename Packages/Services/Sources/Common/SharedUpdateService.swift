//
//  Created by Vladislav Kiriukhin on 28.05.2023.
//

import Foundation
import Combine

public final class SharedUpdateService {
    private var _transactionListUpdateNeeded = PassthroughSubject<Void, Never>()

    public var transactionListUpdateNeeded: AnyPublisher<Void, Never> {
        _transactionListUpdateNeeded.eraseToAnyPublisher()
    }

    public init() { }

    public func markAsTransactionListUpdateNeeded() {
        _transactionListUpdateNeeded.send(())
    }
}
