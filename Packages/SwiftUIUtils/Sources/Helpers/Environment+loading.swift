//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import SwiftUI

private struct LoadingKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    public var isLoading: Bool {
        get { self[LoadingKey.self] }
        set { self[LoadingKey.self] = newValue }
    }
}

extension View {
    public func loading(_ value: Bool) -> some View {
        environment(\.isLoading, value)
    }
}
