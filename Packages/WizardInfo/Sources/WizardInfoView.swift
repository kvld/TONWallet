//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import Components
import AnimationView
import SwiftUIBackports
import SwiftUIHelpers

struct WizardInfoView: View {
    let model: WizardInfoModel

    var body: some View {
        ScreenContainer(navigationBarVisibility: model.isNavigationBarVisible ? .visible : .preserveSpace) { proxy in
            ZStack {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        AnimationView(animationName: model.animationName)
                            .frame(width: 124, height: 124)
                            .padding(.bottom, 20)

                        Text(model.title)
                            .fontConfiguration(.title1)
                            .foregroundColor(.text.primary)
                            .padding(.bottom, 12)

                        Text(model.text)
                            .fontConfiguration(.body.regular)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.text.primary)
                    }
                    .padding(.top, 150)
                    .padding(.horizontal, 32)

                    Spacer()
                }

                VStack(spacing: 0) {
                    Spacer(minLength: 16)

                    VStack(spacing: 16) {
                        Button(model.primaryButton.title, action: model.primaryButton.action)
                            .buttonStyle(.action())

                        if let button = model.secondaryButton {
                            Button(button.title, action: button.action)
                                .buttonStyle(.action(background: .outline))
                        } else {
                            Spacer().frame(height: 50)
                        }
                    }
                    .offset(y: -56)
                    .padding(.horizontal, 48)
                }
            }
            .frame(height: proxy.contentSize.height)
        }
    }
}
