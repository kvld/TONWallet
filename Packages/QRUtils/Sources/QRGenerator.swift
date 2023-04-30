//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import Foundation
import QRCodeGenerator
import CoreGraphics
import UIKit.UIGraphics

public enum QRGenerator {
    public static func generate(link: String, width: CGFloat) -> CGImage? {
        guard let qr = try? QRCode.encode(text: link, ecl: .medium) else { return nil }

        let moduleSize = (width / CGFloat(qr.size)).rounded(.down)
        let width = CGFloat(moduleSize) * CGFloat(qr.size)

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: width), false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }

        let telegramIcon = UIImage(named: "ton")
        let marker = UIImage(named: "qr_marker")?.withTintColor(.black)

        let markerSize = moduleSize * 7

        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: width, height: width))

        marker?.draw(in: CGRect(x: 0, y: 0, width: markerSize, height: markerSize))
        marker?.draw(in: CGRect(x: width - markerSize, y: 0, width: markerSize, height: markerSize))
        marker?.draw(in: CGRect(x: 0, y: width - markerSize, width: markerSize, height: markerSize))

        // ecl = 25%, use 8%
        let iconSize: CGFloat = (CGFloat(qr.size) * CGFloat(qr.size) * 0.08).squareRoot().rounded(.down)
        let iconRect = CGRect(
            x: width / 2 - iconSize * moduleSize / 2,
            y: width / 2 - iconSize * moduleSize / 2,
            width: iconSize * moduleSize,
            height: iconSize * moduleSize
        )
        telegramIcon?.draw(in: iconRect)

        var y: CGFloat = 0
        var x: CGFloat = 0

        ctx.setFillColor(UIColor.black.cgColor)

        var qrModules: [[Bool]] = []
        for i in 0..<qr.size {
            x = 0
            var row: [Bool] = []
            for j in 0..<qr.size {
                if (i < 7 && j < 7) || (i >= qr.size - 7 && j < 7) || (i < 7 && j >= qr.size - 7) {
                    row.append(false)
                    continue
                }

                let moduleRect = CGRect(x: x, y: y, width: moduleSize, height: moduleSize)
                let module = qr.getModule(x: i, y: j)

                if iconRect.insetBy(dx: -moduleSize * 0.2, dy: -moduleSize * 0.2).intersects(moduleRect) {
                    row.append(false)
                } else {
                    row.append(module)
                }

                x += moduleSize
            }
            qrModules.append(row)
            y += moduleSize
        }

        func getModule(x: Int, y: Int) -> Bool {
            if x < 0 || y < 0 { return false }
            if x >= qr.size || y >= qr.size { return false }

            return qrModules[x][y]
        }

        y = 0
        for i in 0..<qr.size {
            x = 0
            for j in 0..<qr.size {
                let module = qrModules[i][j]

                if module {
                    let tlCorner = !getModule(x: i - 1, y: j - 1)
                        && !getModule(x: i - 1, y: j)
                        && !getModule(x: i, y: j - 1)
                    let trCorner = !getModule(x: i - 1, y: j + 1)
                        && !getModule(x: i - 1, y: j)
                        && !getModule(x: i, y: j + 1)
                    let blCorner = !getModule(x: i + 1, y: j - 1)
                        && !getModule(x: i + 1, y: j)
                        && !getModule(x: i, y: j - 1)
                    let brCorner = !getModule(x: i + 1, y: j + 1)
                        && !getModule(x: i + 1, y: j)
                        && !getModule(x: i, y: j + 1)

                    let moduleRect = CGRect(x: x, y: y, width: moduleSize, height: moduleSize)

                    let path = UIBezierPath(
                        roundedRect: moduleRect,
                        byRoundingCorners: UIRectCorner(
                            (tlCorner ? [UIRectCorner.topLeft] : [])
                            + (trCorner ? [UIRectCorner.topRight] : [])
                            + (blCorner ? [UIRectCorner.bottomLeft] : [])
                            + (brCorner ? [UIRectCorner.bottomRight] : [])
                        ),
                        cornerRadii: CGSize(width: 2.0, height: 2.0)
                    )

                    ctx.addPath(path.cgPath)
                    ctx.fillPath()
                }

                x += moduleSize
            }
            y += moduleSize
        }

        return UIGraphicsGetImageFromCurrentImageContext()?.cgImage
    }
}
