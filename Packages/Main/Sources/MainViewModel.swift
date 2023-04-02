//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {
    weak var output: MainModuleOutput?

    private var isInitial = true
}

extension MainViewModel {
    func loadInitial() {
        guard isInitial else {
            return
        }

        isInitial = false
        output?.showWizard()
    }
}
