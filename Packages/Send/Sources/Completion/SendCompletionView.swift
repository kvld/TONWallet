//
//  Created by Vladislav Kiriukhin on 13.05.2023.
//

import SwiftUI
import SendState
import SwiftUIHelpers
import Components
import AnimationView

struct SendCompletionView: View {
    let stage: SendCompletionStage
    @ObservedObject var viewModel: SendViewModel

    var body: some View {
        ScreenContainer(
            navigationBarLeftButton: nil,
            navigationBarRightButton: .done,
            extendBarHeight: true
        ) { proxy in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Spacer()
                    
                    Group {
                        switch stage {
                        case .waiting:
                            AnimationView(animationName: "waiting_ton")
                        case .completed:
                            AnimationView(animationName: "success", repeatInfinitely: false)
                        }
                    }
                    .frame(width: 124, height: 124)
                    .padding(.bottom, 26)

                    Group {
                        switch stage {
                        case .waiting:
                            Text("Sending TON")
                        case .completed:
                            Text("Done!")
                        }
                    }
                    .fontConfiguration(.title1)
                    .foregroundColor(.text.primary)
                    .padding(.bottom, 12)

                    Group {
                        switch stage {
                        case .waiting:
                            Text("Please wait a few seconds for your transaction to be processed…")
                        case .completed:
                            Text("\(viewModel.state.amount?.formatted.formatted ?? "") Toncoin have been sent to")
                        }
                    }
                    .multilineTextAlignment(.center)
                    .fontConfiguration(.body.regular)
                    .foregroundColor(.text.primary)
                    .padding(.horizontal, 32)

                    if case .completed = stage {
                        Text("\(viewModel.state.address?.value ?? "")")
                            .multilineTextAlignment(.center)
                            .fontConfiguration(.body.mono)
                            .foregroundColor(.text.primary)
                            .padding(.horizontal, 32)
                            .padding(.top, 24)
                    }

                    Spacer()
                }
                .padding(.bottom, 130)

                VStack(spacing: 0) {
                    Spacer()

                    Button("View my wallet") {

                    }
                    .buttonStyle(.action())
                    .loading(viewModel.state.isLoading)
                    .padding(.horizontal, 16)

                    DeviceRelatedBottomSpacer()
                }
            }
            .frame(height: proxy.contentSize.height)
        }
    }
}

private struct TableSectionView: View {
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            HStack {
                Text(title.uppercased())
                    .foregroundColor(.text.secondary)
                    .fontConfiguration(.footnote)
                Spacer()
            }
            .padding(.bottom, 4)
        }
        .frame(height: 44)
        .padding(.horizontal, 32)
    }
}
