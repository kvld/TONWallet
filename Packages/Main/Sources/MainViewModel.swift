//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import TON
import Combine

final class MainViewModel: ObservableObject {
    weak var output: MainModuleOutput?

    private var cancellables = Set<AnyCancellable>()

    private let walletStateService: WalletStateService

    init(walletStateService: WalletStateService) {
        self.walletStateService = walletStateService
    }
}

extension MainViewModel {
    func loadInitial() {
        walletStateService.walletState
            .filter { !$0.isUnknown }
            .sink { [weak self] state in
                guard let self else {
                    return
                }

                if case .fetched(let walletInfo) = state, let walletInfo {
                    self.loadTransactionAndBalance()
                } else {
                    self.output?.showWizard()
                }
            }
            .store(in: &cancellables)
    }

    func loadTransactionAndBalance() {
        print("DD -> load")
    }
}
