//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation

public protocol StorageProvider {
    func store<T: Encodable>(_ object: T, withKey key: String) throws
    func retrieve<T: Decodable>(with key: String) throws -> T?
    func remove(for key: String)
}
