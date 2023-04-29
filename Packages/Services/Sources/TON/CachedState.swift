//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import Foundation

struct CachedState: Codable {
    var lastKnownTransaction: TransactionID?
}

extension CachedState {
    static var `default`: CachedState {
        .init(
            lastKnownTransaction: nil
        )
    }
}
