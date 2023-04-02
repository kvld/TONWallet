//
//  Created by Vladislav Kiriukhin on 29.03.2023.
//

import Foundation
import SwiftUI

extension Color {
    public struct Background {
        public let content = Color(red: 1, green: 1, blue: 1)
        public let grouped = Color(red: 239 / 255, green: 239 / 255, blue: 243 / 255)
        public let elevation = Color(red: 1, green: 1, blue: 1)
        public let base = Color(red: 0, green: 0, blue: 0)
    }

    public struct Text {
        public let primary = Color(red: 0, green: 0, blue: 0)
        public let secondary = Color(red: 60 / 255, green: 60 / 255, blue: 67 / 255, opacity: 0.6)
        public let tertiary = Color(red: 60 / 255, green: 60 / 255, blue: 67 / 255, opacity: 0.3)
        public let overlay = Color(red: 1, green: 1, blue: 1)
    }

    public struct Accent {
        public let main = Color(red: 50 / 255, green: 170 / 255, blue: 254 / 255)
        public let app = Color.accentColor
    }

    public struct System {
        public let red = Color(red: 255 / 255, green: 59 / 255, blue: 48 / 255)
        public let green = Color(red: 0 / 255, green: 175 / 255, blue: 44 / 255)
        public let orange = Color(red: 255 / 255, green: 149 / 255, blue: 0 / 255)
    }

    public static var separator: Color {
        Color(red: 60 / 255, green: 60 / 255, blue: 67 / 255, opacity: 0.36)
    }

    public static var background: Background {
        .init()
    }

    public static var text: Text {
        .init()
    }

    public static var accent: Accent {
        .init()
    }

    public static var system: System {
        .init()
    }
}

