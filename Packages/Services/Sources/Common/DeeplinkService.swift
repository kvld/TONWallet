//
//  Created by Vladislav Kiriukhin on 21.05.2023.
//

import Foundation

public final class DeeplinkService {
    public init() { }

    public func handleDeeplink(for url: URL) -> Action? {
        guard url.scheme == "ton" else {
            return nil
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        switch components.host {
        case "transfer":
            return handleTransfer(components: components)
        default:
            return nil
        }
    }

    public enum Action {
        case transfer(address: String?, amount: Int64?, comment: String?)
    }
}

extension DeeplinkService {
    private func handleTransfer(components: URLComponents) -> Action {
        .transfer(
            address: components.path.first == "/" ? String(components.path.dropFirst()) : components.path,
            amount: components.queryItems?.first(where: { $0.name == "amount" })?.value.flatMap { Int64($0) },
            comment: components.queryItems?.first(where: { $0.name == "text" })?.value?.removingPercentEncoding
        )
    }
}
