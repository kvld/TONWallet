//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import Foundation
import SwiftUI
import Components

struct TransactionListDateView: View {
    let date: String

    var body: some View {
        HStack(spacing: 0) {
            Text(date)
                .foregroundColor(.text.primary)
                .fontConfiguration(.body.semibold)
            Spacer()
        }
        .clipped(antialiased: false)
        .padding(.top, 20)
        .padding(.bottom, -2)
        .zIndex(100)
    }
}
