import SwiftUI

extension Color {
    // You must use 'static let' for these to be found!
    static let purple40 = Color(hex: 0x6650a4)
    static let purple80 = Color(hex: 0xD0BCFF)
    static let darkBackground = Color(hex: 0x121212)
    static let darkSurface = Color(hex: 0x212121)
    static let onDark = Color(hex: 0xE0E0E0)
    
    // This helper must be here too
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
