//
//  Created by Vladislav Kiriukhin on 09.04.2023.
//

import Foundation
import TONSchema

struct TONClientResponse: Decodable {
    let uuid: UUID?
    let type: String
    let decoder: Decoder

    var isError: Bool {
        type == TONSchema.Error._type
    }

    var error: Error? {
        if isError {
            return try? TONSchema.Error(from: decoder)
        }
        return nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TONRequestCodingKeys.self)
        self.uuid = UUID(uuidString: try container.decode(String.self, forKey: ._extra))
        self.type = try container.decode(String.self, forKey: ._type)
        self.decoder = decoder
    }
}
