//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import UIKit
import QRUtils
import TON

final class ReceiveViewModel: ObservableObject {
    @Published var address: String
    @Published var link: String
    @Published var qr: UIImage?

    weak var output: ReceiveModuleOutput?

    init(walletInfo: WalletInfo) {
        address = walletInfo.address.value
        link = walletInfo.address.transferLink
        generateQR(for: walletInfo.address.transferLink)
    }

    func share() {
        guard let url = URL(string: link) else {
            return
        }

        output?.share(url: url)
    }

    private func generateQR(for link: String) {
        guard let qr = QRGenerator.generate(link: link, width: 220) else {
            return
        }

        self.qr = UIImage(cgImage: qr)
    }
}
