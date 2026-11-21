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
    /// Top and bottom of the screen backdrop gradient (1.1 Liquid Glass refresh).
    static let backgroundTop = dynamic(light: 0xDCE8F4, dark: 0x10294A)
    static let backgroundBottom = dynamic(light: 0xF7F9FB, dark: 0x060F1C)
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

/// Wide screens (iPad) cap text and controls at a readable column, centred.
/// iPhone screens are narrower than the cap, so nothing changes there.
enum ReadableWidth {
    static let max: CGFloat = 600
}

private struct ReadableListWidth: ViewModifier {
    @State private var width: CGFloat = 0

    func body(content: Content) -> some View {
        Group {
            // Any explicit margin replaces the list's own insets, so leave
            // narrow screens (every iPhone) completely untouched.
            if width > ReadableWidth.max + 80 {
                content.contentMargins(.horizontal, (width - ReadableWidth.max) / 2, for: .scrollContent)
            } else {
                content
            }
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
    }
}

extension View {
    /// For stacks and scroll view content: at most `ReadableWidth.max` wide, centred.
    func readableWidth() -> some View {
        frame(maxWidth: ReadableWidth.max).frame(maxWidth: .infinity)
    }

    /// For `List` and `Form`, which size their own rows: widens the side margins
    /// so the rows are at most `ReadableWidth.max` wide, centred.
    func readableListWidth() -> some View { modifier(ReadableListWidth()) }
}

// MARK: - Liquid Glass (iOS 26 and later), with the 1.0 look as the fallback

/// Screen backdrop: a quiet sea gradient that gives the glass layer something to refract.
struct AppBackground: View {
    var body: some View {
        LinearGradient(colors: [Theme.backgroundTop, Theme.background, Theme.backgroundBottom],
                       startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

extension View {
    /// Applies the app backdrop. Lists and forms hide their own grey background so it shows through.
    func appBackground() -> some View {
        scrollContentBackground(.hidden)
            .background { AppBackground() }
    }

    /// Tab bar shrinks while reading and returns on scroll up (iOS 26 and later).
    @ViewBuilder func glassTabBar() -> some View {
        if #available(iOS 26.0, *) {
            tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
    }

    /// A glass surface in `shape`, optionally tinted and touch-responsive.
    /// Before iOS 26 it falls back to the 1.0 solid fill with a hairline border.
    @ViewBuilder func glassSurface<S: InsettableShape>(
        in shape: S, tint: Color? = nil, interactive: Bool = false,
        fallback: Color = Theme.card, fallbackStroke: Color? = Theme.border
    ) -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(Glass.regular.tint(tint).interactive(interactive), in: shape)
        } else if let fallbackStroke {
            background(fallback, in: shape).overlay(shape.stroke(fallbackStroke, lineWidth: 1))
        } else {
            background(fallback, in: shape)
        }
    }
}

struct CardStyle: ViewModifier {
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 20
    var interactive = false
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .glassSurface(in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
                          interactive: interactive)
    }
}

extension View {
    func card(padding: CGFloat = 16, cornerRadius: CGFloat = 20, interactive: Bool = false) -> some View {
        modifier(CardStyle(padding: padding, cornerRadius: cornerRadius, interactive: interactive))
    }
}

/// Main call to action: tinted glass capsule on iOS 26 and later.
struct PrimaryButtonStyle: ButtonStyle {
    /// Fixed deep orange in both modes: white text on the dark-mode accent (#FF8A3D) is only about 2.3:1.
    var fill: Color = Color(hex: 0xC2410C)
    func makeBody(configuration: Configuration) -> some View {
        let label = configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 50)
        if #available(iOS 26.0, *) {
            label.glassEffect(.regular.tint(fill).interactive(), in: Capsule())
        } else {
            label.background(fill.opacity(configuration.isPressed ? 0.8 : 1),
                             in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

/// Secondary action: clear glass capsule on iOS 26 and later.
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let label = configuration.label
            .font(.headline)
            .foregroundStyle(Theme.navy)
            .frame(maxWidth: .infinity, minHeight: 50)
        if #available(iOS 26.0, *) {
            label.glassEffect(.regular.interactive(), in: Capsule())
        } else {
            label
                .background(Theme.card.opacity(configuration.isPressed ? 0.7 : 1),
                            in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Theme.border))
        }
    }
}

/// The one place that decides the direction of non-interface text. Interface
/// chrome (navigation, tab bar, buttons, labels) always follows the interface language.
enum ContentDirection {
    /// Radio procedure: always English, always left-to-right, in every locale.
    case procedure
    /// Lessons, quiz prompts, answers and explanations. English content stays
    /// left-to-right in a right-to-left interface; a translated content pack
    /// follows the interface direction.
    case study

    static func resolve(_ kind: ContentDirection, contentLanguage: String,
                        interface: LayoutDirection) -> LayoutDirection {
        switch kind {
        case .procedure: .leftToRight
        case .study: contentLanguage == "en" ? .leftToRight : interface
        }
    }
}

private struct ContentDirectionModifier: ViewModifier {
    let kind: ContentDirection
    @Environment(ContentStore.self) private var store
    @Environment(\.layoutDirection) private var interface

    func body(content: Content) -> some View {
        content.environment(\.layoutDirection,
                            ContentDirection.resolve(kind, contentLanguage: store.contentLanguage,
                                                     interface: interface))
    }
}

extension View {
    /// Applies `ContentDirection` to this view and everything inside it.
    func contentDirection(_ kind: ContentDirection = .study) -> some View {
        modifier(ContentDirectionModifier(kind: kind))
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
            .contentDirection(.procedure)
    }
}
