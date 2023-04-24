//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import UIKit
import SwiftUI

@MainActor
public protocol Router {
    var viewController: UIViewController { get }
    var canDismissInteractively: Bool { get }
}

extension Router {
    public var canDismissInteractively: Bool { true }
}

public class HostingRouter<View: SwiftUI.View, Module>: Router {
    private let view: View
    private let module: Module?

    public lazy var viewController: UIViewController = UIHostingController(rootView: view)

    init(view: View, module: Module? = nil) {
        self.view = view
        self.module = module
    }
}
