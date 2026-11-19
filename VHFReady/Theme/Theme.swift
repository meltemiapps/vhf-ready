import SwiftUI
import UIKit

/// Original colour palette for VHF Ready. Deliberately generic nautical navy and
/// signal orange; not derived from any organisation's branding.
enum Theme {
    static let navy = dynamic(light: 0x0B2540, dark: 0xE8F0F8)
    static let navyFill = dynamic(light: 0x0B2540, dark: 0x16324F)
    static let accent = dynamic(light: 0xC2410C, dark: 0xFF8A3D)
    static let accentBright = Color(hex: 0xFF8A3D)
    static let link = dynamic(light: 0x0B5CAD, dark: 0x7DB8F0)
    static let background = dynamic(light: 0xF3F6F9, dark: 0x0A1626)
    static let card = dynamic(light: 0xFFFFFF, dark: 0x13243A)
    static let border = dynamic(light: 0xDCE4EC, dark: 0x274563)
    static let secondaryText = dynamic(light: 0x4A5D72, dark: 0xA9BBCD)
    static let success = dynamic(light: 0x1F7A51, dark: 0x5BD39A)
    static let successFill = dynamic(light: 0xE9F6EF, dark: 0x123A2A)
    static let warningFill = dynamic(light: 0xFFF3EC, dark: 0x3A2010)
    static let warningText = dynamic(light: 0x7C2D12, dark: 0xFFC9A6)
    static let error = dynamic(light: 0xB42318, dark: 0xFF8A80)
    static let errorFill = dynamic(light: 0xFDECEA, dark: 0x3D1512)

    private static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
    }
}

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}

extension Color {
    init(hex: UInt32) { self.init(UIColor(hex: hex)) }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Theme.border, lineWidth: 1)
            )
    }
}

extension View {
    func card() -> some View { modifier(CardStyle()) }
}

struct PrimaryButtonStyle: ButtonStyle {
    var fill: Color = Theme.accent
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(fill.opacity(configuration.isPressed ? 0.8 : 1),
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Theme.navy)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Theme.card.opacity(configuration.isPressed ? 0.7 : 1),
                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Theme.border))
    }
}

/// Radio procedure text is always English and always left-to-right,
/// including when the interface runs in Arabic.
struct ProcedureText: View {
    let text: String
    var body: some View {
        Text(verbatim: text)
            .font(.system(.callout, design: .monospaced))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .environment(\.layoutDirection, .leftToRight)
    }
}
