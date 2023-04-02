//
//  Created by Vladislav Kiriukhin on 01.04.2023.
//

import Foundation
@_implementationOnly import RLottie
@_implementationOnly import GZIP
import UIKit

public final class RLottieAnimation {
    private let animationName: String


    public init(animationName: String) {
        self.animationName = animationName

    }

    @MainActor
    public func render(in renderSize: CGSize) async -> UIImage? {
        let data = await Task { () -> (frames: [CGImage], duration: Double)? in
            guard let wrapper = RLottieAnimationWrapper.makeFromData(animationName: animationName) else {
                return nil
            }

            guard let frames = wrapper.renderFrames(in: renderSize), let duration = wrapper.duration else {
                return nil
            }

            return (frames, duration)
        }
        .value

        guard let frames = data?.frames, let duration = data?.duration else {
            return nil
        }

        return UIImage.animatedImage(with: frames.map { UIImage(cgImage: $0) }, duration: duration)
    }
}

private final class RLottieAnimationWrapper {
    private var animation: OpaquePointer

    var size: CGSize? {
        let width = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        let height = UnsafeMutablePointer<Int>.allocate(capacity: 1)

        defer {
            width.deallocate()
            height.deallocate()
        }

        lottie_animation_get_size(animation, width, height)

        return .init(width: width.pointee, height: height.pointee)
    }

    var frameCount: Int? {
        lottie_animation_get_totalframe(animation)
    }

    var duration: Double? {
        lottie_animation_get_duration(animation)
    }

    private init(animation: OpaquePointer) {
        self.animation = animation
    }

    func renderFrames(in renderSize: CGSize) -> [CGImage]? {
        guard let size, let frameCount,
              size.width > 0, size.height > 0, frameCount > 0 else {
            assertionFailure("Invalid lottie animation params")
            return nil
        }

        guard let space = CGColorSpace(name: CGColorSpace.sRGB) else {
            assertionFailure("Invalid color space")
            return nil
        }

        let buffer = UnsafeMutablePointer<UInt32>.allocate(capacity: Int(renderSize.width) * Int(renderSize.height))
        let bytesPerRow = Int(renderSize.width * 4)

        guard let context = CGContext(
            data: buffer,
            width: Int(renderSize.width),
            height: Int(renderSize.height),
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: space,
            bitmapInfo: kCGBitmapByteOrder32Host.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else {
            assertionFailure("Unable to init CGContext")
            return nil
        }

        var frames: [CGImage] = []

        for i in 0..<frameCount {
            lottie_animation_render(animation, i, buffer, Int(renderSize.width), Int(renderSize.height), bytesPerRow)

            if let bitmap = context.makeImage() {
                frames.append(bitmap)
            }
        }

        return frames
    }

    static func makeFromData(animationName: String) -> RLottieAnimationWrapper? {
        guard let animationFile = NSDataAsset(name: animationName) else {
            assertionFailure("Missing animation with name \(animationName)")
            return nil
        }

        let cacheKey = ""
        let resourcePath = Bundle.main.resourcePath ?? ""

        guard let unzippedData = animationFile.data.gunzipped() else {
            assertionFailure("Unable to gunzip animation data")
            return nil
        }

        guard let animationDataPointer = unzippedData.withUnsafeBytes({ bytes -> UnsafePointer<Int8>? in
            guard let bytes = bytes.bindMemory(to: Int8.self).baseAddress else {
                return nil
            }

            return bytes
        }) else {
            assertionFailure("Invalid animation data")
            return nil
        }

        guard let cacheKeyPointer = cacheKey.asPointer(), let resourcePathPointer = resourcePath.asPointer() else {
            assertionFailure("Invalid parameters")
            return nil
        }

        guard let lottieAnimation = lottie_animation_from_data(
            animationDataPointer,
            cacheKeyPointer,
            resourcePathPointer
        ) else {
            assertionFailure("Unable to load lottie animation with name \(animationName)")
            return nil
        }

        return .init(animation: lottieAnimation)
    }

    deinit {
        lottie_animation_destroy(animation)
    }
}

extension String {
    fileprivate func asPointer() -> UnsafePointer<Int8>? {
        guard let pointer = data(using: .utf8)?.withUnsafeBytes({ bytes -> UnsafePointer<Int8>? in
            guard let bytes = bytes.bindMemory(to: Int8.self).baseAddress else {
                return nil
            }

            return bytes
        }) else {
            assertionFailure("Invalid string data for \(self)")
            return nil
        }

        return pointer
    }
}

extension Data {
    fileprivate func gunzipped() -> Data? {
        NSData(data: self).gunzipped()
    }
}
