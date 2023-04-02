//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI

public final class WizardMnemonicModule {
    public lazy var view: AnyView = {
        AnyView(
            WizardMnemonicView(
                onDoneTap: onDoneTap
            )
        )
    }()

    private let onDoneTap: () -> Void

    public init(onDoneTap: @escaping () -> Void) {
        self.onDoneTap = onDoneTap
    }
}
