//
//  Created by Vladislav Kiriukhin on 29.03.2023.
//

import Foundation
import UIKit
import SwiftUI
import RLottieAnimation

final class _AnimationView: UIView {
    private let animation: RLottieAnimation
    private let repeatInfinitely: Bool
    private var size: CGSize = .zero
    private let finalProgress: Double

    private let imageView = UIImageView()

    init(frame: CGRect, animationName: String, repeatInfinitely: Bool, finalProgress: Double) {
        self.animation = RLottieAnimation(animationName: animationName)
        self.repeatInfinitely = repeatInfinitely
        self.finalProgress = finalProgress

        super.init(frame: frame)

        addSubview(imageView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = bounds

        if bounds.size != size {
            size = bounds.size

            let scale = window?.screen.scale ?? 1
            let renderSize = CGSize(width: bounds.width * scale, height: bounds.height * scale)

            Task { @MainActor in
                let animation = await animation.render(in: renderSize)

                let framesCount = animation?.images?.count ?? 0
                let animationFramesCount = Int(Double(framesCount) * finalProgress)

                imageView.animationImages = Array(animation?.images?.prefix(animationFramesCount) ?? .init())
                imageView.animationRepeatCount = repeatInfinitely ? 0 : 1
                imageView.animationDuration = (animation?.duration ?? 0.0) * finalProgress
                imageView.image = imageView.animationImages?.last

                imageView.startAnimating()
            }
        }
    }
}

public struct AnimationView: UIViewRepresentable {
    private let animationName: String
    private let repeatInfinitely: Bool
    private let finalProgress: Double

    public init(animationName: String, repeatInfinitely: Bool = true, finalProgress: Double = 1.0) {
        self.animationName = animationName
        self.repeatInfinitely = repeatInfinitely
        self.finalProgress = finalProgress
    }

    public func makeUIView(context: Context) -> some UIView {
        _AnimationView(
            frame: .zero,
            animationName: animationName,
            repeatInfinitely: repeatInfinitely,
            finalProgress: finalProgress
        )
    }

    public func updateUIView(_ uiView: some UIView, context: Context) { }
}
