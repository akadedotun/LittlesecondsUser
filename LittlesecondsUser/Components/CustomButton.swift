import SwiftUI

enum ButtonStyle {
    case primary
    case outline
    case destructive
}

struct CustomButton: View {
    let title: String
    let style: ButtonStyle
    let action: () -> Void

    init(_ title: String, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(backgroundColor)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(borderColor, lineWidth: style == .primary ? 0 : 1.5)
                )
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .outline: return .brandDarkGreen
        case .destructive: return .red
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return .brandDarkGreen
        case .outline, .destructive: return .clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary: return .clear
        case .outline: return .brandDarkGreen
        case .destructive: return .red
        }
    }
}

// MARK: - Pill variant (compact, used in cards)
struct PillButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(Color.brandDarkGreen)
                .cornerRadius(20)
        }
    }
}

struct DestructivePillButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.red)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .overlay(
                    Capsule().stroke(Color.red, lineWidth: 1.5)
                )
        }
    }
}
