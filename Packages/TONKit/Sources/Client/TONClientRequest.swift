//
//  Created by Vladislav Kiriukhin on 09.04.2023.
//

import Foundation
import TONSchema

enum TONRequestCodingKeys: String, CodingKey {
    case _extra = "@extra"
    case _type = "@type"
}

struct TONClientRequest<Function: TLFunction>: Encodable {
    private let uuid: UUID
    private let function: Function

    init(uuid: UUID, function: Function) {
        self.uuid = uuid
        self.function = function
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TONRequestCodingKeys.self)
        try container.encode(uuid.uuidString, forKey: ._extra)
        try function.encode(to: encoder)
    }
}
