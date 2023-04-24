//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import SwiftUI

public struct LoadingIndicator: View {
    public let lineWidth: CGFloat

    @State private var rotationAngle = 0.0

    public init(lineWidth: CGFloat) {
        self.lineWidth = lineWidth
    }

    public var body: some View {
        Circle()
            .trim(from: 0.3, to: 1.0)
            .stroke(style: .init(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                    rotationAngle = 360.0
                }
            }
    }
}

#if DEBUG
struct LoadingIndicator_Preview: PreviewProvider {
    static var previews: some View {
        LoadingIndicator(lineWidth: 2.3)
            .frame(width: 16, height: 16)
            .foregroundColor(.red)
    }
}
#endif
