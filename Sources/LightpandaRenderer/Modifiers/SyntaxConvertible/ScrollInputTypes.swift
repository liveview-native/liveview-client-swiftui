import SwiftUI
import SwiftSyntax

// MARK: - ScrollInputBehavior

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension ScrollInputBehavior: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }

        switch memberAccess.declName.baseName.text {
        case "enabled": self = .enabled
        case "disabled": self = .disabled
        default: return nil
        }
    }
}
#endif

// MARK: - ScrollInputKind

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
extension ScrollInputKind: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access (e.g., .all)
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            #if os(visionOS)
            case "handGestureShortcut": self = .handGestureShortcut
            case "look": self = .look
            #endif
            default: return nil
            }
            return
        }

        // Handle function call (e.g., .look(axes: .vertical))
        if let funcCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = funcCall.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "look":
                #if os(visionOS)
                let axes: Axis.Set = funcCall.argument(named: "axes").flatMap({ Axis.Set(syntax: $0.expression) }) ?? [.vertical]
                self = .look(axes: axes)
                #else
                return nil
                #endif
            default: return nil
            }
            return
        }

        return nil
    }
}
#endif
