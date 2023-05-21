//
//  Created by Vladislav Kiriukhin on 21.05.2023.
//

import Foundation
import TON
import Storage

public func resolve<T>() -> T {
    ServiceLocator.shared.resolveService()
}

final class ServiceLocator {
    static let shared: ServiceLocator = .init()

    private let queue = DispatchQueue.global(qos: .userInteractive)
    private var storage: [ObjectIdentifier: Any] = [:]

    private var isInitialized = false

    private init() { }

    private func registerAll() {
        register { Storage() }

        register {
            ConfigService(storage: resolve())
        }

        register {
            // testnet: https://ton.org/testnet-global.config.json
            // mainnet: https://ton.org/global-config.json
            let url = URL(string: "https://ton.org/global-config.json")!
            return TONService(storage: resolve(), configURL: url)
        }

        register {
            BiometricService()
        }
    }
}

extension ServiceLocator {
    func resolveService<T>() -> T {
        if !isInitialized {
            isInitialized = true
            registerAll()
        }

        return queue.sync {
            self.storage[.init(T.self)] as! T
        }
    }

    func register<T>(_ action: @escaping () -> T) {
        queue.sync {
            self.storage[.init(T.self)] = action()
        }
    }
}
