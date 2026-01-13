import SwiftUI
import SwiftSyntax

public struct AnyGaugeStyle: SyntaxConvertible, Sendable {
    enum Style: Sendable {
        case automatic
        case accessoryCircular
        case accessoryCircularCapacity
        case accessoryLinear
        case accessoryLinearCapacity
        #if os(watchOS)
        case circular
        case linear
        #endif
        case linearCapacity
    }

    let style: Style

    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else { return nil }

        switch memberAccess.declName.baseName.text {
        case "automatic":
            self.style = .automatic
        case "accessoryCircular":
            self.style = .accessoryCircular
        case "accessoryCircularCapacity":
            self.style = .accessoryCircularCapacity
        case "accessoryLinear":
            self.style = .accessoryLinear
        case "accessoryLinearCapacity":
            self.style = .accessoryLinearCapacity
        #if os(watchOS)
        case "circular":
            self.style = .circular
        case "linear":
            self.style = .linear
        #endif
        case "linearCapacity":
            self.style = .linearCapacity
        default:
            return nil
        }
    }
}

@MainActor
private func _unboxGaugeStyle(style: some GaugeStyle, on view: some View) -> AnyView {
    AnyView(view.gaugeStyle(style))
}

extension View {
    @MainActor
    func gaugeStyle(_ style: AnyGaugeStyle) -> AnyView {
        switch style.style {
        case .automatic:
            return _unboxGaugeStyle(style: DefaultGaugeStyle(), on: self)
        case .accessoryCircular:
            return _unboxGaugeStyle(style: AccessoryCircularGaugeStyle(), on: self)
        case .accessoryCircularCapacity:
            return _unboxGaugeStyle(style: AccessoryCircularCapacityGaugeStyle(), on: self)
        case .accessoryLinear:
            return _unboxGaugeStyle(style: AccessoryLinearGaugeStyle(), on: self)
        case .accessoryLinearCapacity:
            return _unboxGaugeStyle(style: AccessoryLinearCapacityGaugeStyle(), on: self)
        #if os(watchOS)
        case .circular:
            return _unboxGaugeStyle(style: CircularGaugeStyle(), on: self)
        case .linear:
            return _unboxGaugeStyle(style: LinearGaugeStyle(), on: self)
        #endif
        case .linearCapacity:
            return _unboxGaugeStyle(style: LinearCapacityGaugeStyle(), on: self)
        }
    }
}
