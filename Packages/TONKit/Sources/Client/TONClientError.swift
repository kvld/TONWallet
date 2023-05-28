//
//  Created by Vladislav Kiriukhin on 09.04.2023.
//

import Foundation
import TONSchema

extension TONSchema.Error: Swift.Error { }

extension TONClient {
    public struct TimeoutError: Swift.Error { }

    public struct ReachedMaxRetriesCountError: Swift.Error { }

    public struct InvalidLiteServerError: Swift.Error { }

    public struct ParsingResponseError: Swift.Error {
        let expectedType: String
        let error: Swift.Error
    }
}
