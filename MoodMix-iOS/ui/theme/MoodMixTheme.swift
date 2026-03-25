//
//  MoodMixTheme.swift
//  MoodMix-iOS
//
//  Created by Penny on 3/27/26.
//


import SwiftUI
import UIKit

// Helper to create UIColors from hex
extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 08) & 0xff) / 255,
            blue: CGFloat((hex >> 00) & 0xff) / 255,
            alpha: alpha
        )
    }
    
    static let purple40 = UIColor(hex: 0x6650a4)
    static let purple80 = UIColor(hex: 0xD0BCFF)
    
    static let purpleGrey40 = UIColor(hex: 0x625b71)
    static let purpleGrey80 = UIColor(hex: 0xCCC2DC)
    
    static let pink40 = UIColor(hex: 0x7D5260)
    static let pink80 = UIColor(hex: 0xEFB8C8)
    
    static let darkBackground = UIColor(hex: 0x121212)
    static let darkSurface = UIColor(hex: 0x212121)
    static let onDark = UIColor(hex: 0xE0E0E0)
}

extension Color {
    /// MoodMix Semantic Colors
    /// These automatically switch based on the device's Color Scheme (Light/Dark)
    
    static let themePrimary = Color(UIColor { traits in
        return traits.userInterfaceStyle == .dark ? .purple80 : .purple40
    })
    
    static let themeSecondary = Color(UIColor { traits in
        return traits.userInterfaceStyle == .dark ? .purpleGrey80 : .purpleGrey40
    })
    
    static let themeTertiary = Color(UIColor { traits in
        return traits.userInterfaceStyle == .dark ? .pink80 : .pink40
    })
    
    static let themeBackground = Color(UIColor { traits in
        // Matches your custom DarkBackground in dark mode, system default in light
        return traits.userInterfaceStyle == .dark ? .darkBackground : .systemBackground
    })
    
    static let themeSurface = Color(UIColor { traits in
        return traits.userInterfaceStyle == .dark ? .darkSurface : .secondarySystemBackground
    })
    
    static let themeOnSurface = Color(UIColor { traits in
        return traits.userInterfaceStyle == .dark ? .onDark : .label
    })
}

/// The "Main" View Modifier to apply global styles (Typography & Theme)
struct MoodMixTheme<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.themeBackground)
            .foregroundColor(Color.themeOnSurface)
            // Typography in SwiftUI is usually applied at the component level,
            // but we can set a default environment here if needed.
    }
}
