import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let brandDarkGreen = Color(red: 0.08, green: 0.20, blue: 0.04)
    static let backgroundGray = Color(UIColor.systemGroupedBackground)
    static let cardWhite = Color(UIColor.systemBackground)
}

// MARK: - Card Shadow Modifier
struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

extension View {
    func cardShadow() -> some View {
        modifier(CardShadow())
    }
}
