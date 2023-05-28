//
//  Created by Vladislav Kiriukhin on 27.05.2023.
//

import SwiftUI

public struct AlertView: View {
    @Binding private var isPresented: Bool
    private let title: String
    private let message: String

    public init(isPresented: Binding<Bool>, title: String, message: String) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
    }

    public var body: some View {
        ZStack {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.octagon.fill")
                    .resizable()
                    .frame(width: 20, height: 20)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .fontConfiguration(.subheadline.semibold)

                    Text(message)
                        .fontConfiguration(.subheadline.regular)
                }

                Spacer(minLength: 0)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background {
            Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255).opacity(0.8)
        }
        .background(Color.clear.blur(radius: 25))
        .cornerRadius(10)
        .frame(minHeight: 54)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            isPresented = false
        }
        .onAppear {
            if isPresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    isPresented = false
                }
            }
        }
        .transition(.opacity.animation(.easeInOut(duration: 0.25)))
    }
}
