import SwiftUI
import SwiftSyntax

public struct AnyDatePickerStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case compact
        case graphical
        #if os(iOS) || os(watchOS)
        case wheel
        #endif
        #if os(macOS)
        case field
        case stepperField
        #endif
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "compact":
            self.style = .compact
        case "graphical":
            self.style = .graphical
        #if os(iOS) || os(watchOS)
        case "wheel":
            self.style = .wheel
        #endif
        #if os(macOS)
        case "field":
            self.style = .field
        case "stepperField":
            self.style = .stepperField
        #endif
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxDatePickerStyle(style: some DatePickerStyle, on view: some View) -> AnyView {
    AnyView(view.datePickerStyle(style))
}

extension View {
    @MainActor
    func datePickerStyle(_ style: AnyDatePickerStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxDatePickerStyle(style: DefaultDatePickerStyle(), on: self)
        case .compact:
            return _unboxDatePickerStyle(style: CompactDatePickerStyle(), on: self)
        case .graphical:
            return _unboxDatePickerStyle(style: GraphicalDatePickerStyle(), on: self)
        #if os(iOS) || os(watchOS)
        case .wheel:
            return _unboxDatePickerStyle(style: WheelDatePickerStyle(), on: self)
        #endif
        #if os(macOS)
        case .field:
            return _unboxDatePickerStyle(style: FieldDatePickerStyle(), on: self)
        case .stepperField:
            return _unboxDatePickerStyle(style: StepperFieldDatePickerStyle(), on: self)
        #endif
        }
    }
}
