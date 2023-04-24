//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import SwiftUI

struct RefreshControlView: View {
    var body: some View {
        HStack {
            Spacer()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                .frame(width: 36, height: 36)

            Spacer()
        }
        .frame(height: 44)
        .background(Color.black)
    }
}
