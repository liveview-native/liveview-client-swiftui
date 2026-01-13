import SwiftUI
import SwiftSyntax

public struct AnyPickerStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case inline
        case menu
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        case navigationLink
        #endif
        case palette
        case segmented
        #if os(iOS) || os(watchOS)
        case wheel
        #endif
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "inline":
            self.style = .inline
        case "menu":
            self.style = .menu
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        case "navigationLink":
            self.style = .navigationLink
        #endif
        case "palette":
            self.style = .palette
        case "segmented":
            self.style = .segmented
        #if os(iOS) || os(watchOS)
        case "wheel":
            self.style = .wheel
        #endif
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxPickerStyle(style: some PickerStyle, on view: some View) -> AnyView {
    AnyView(view.pickerStyle(style))
}

extension View {
    @MainActor
    func pickerStyle(_ style: AnyPickerStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxPickerStyle(style: DefaultPickerStyle(), on: self)
        case .inline:
            return _unboxPickerStyle(style: InlinePickerStyle(), on: self)
        case .menu:
            return _unboxPickerStyle(style: MenuPickerStyle(), on: self)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        case .navigationLink:
            return _unboxPickerStyle(style: NavigationLinkPickerStyle(), on: self)
        #endif
        case .palette:
            return _unboxPickerStyle(style: PalettePickerStyle(), on: self)
        case .segmented:
            return _unboxPickerStyle(style: SegmentedPickerStyle(), on: self)
        #if os(iOS) || os(watchOS)
        case .wheel:
            return _unboxPickerStyle(style: WheelPickerStyle(), on: self)
        #endif
        }
    }
}
