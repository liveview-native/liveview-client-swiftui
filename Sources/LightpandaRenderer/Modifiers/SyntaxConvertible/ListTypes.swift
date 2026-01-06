import SwiftUI
import SwiftSyntax

// MARK: - ControlSize

extension ControlSize: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "mini":
                self = .mini
            case "small":
                self = .small
            case "regular":
                self = .regular
            case "large":
                self = .large
            case "extraLarge":
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                    self = .extraLarge
                } else {
                    return nil
                }
            default:
                return nil
            }
            return
        }
        return nil
    }
}

// MARK: - AnyListStyle

/// Type-erased list style for runtime parsing.
/// Uses an enum internally since ListStyle has internal protocol requirements.
public struct AnyListStyle: @unchecked Sendable {
    enum Style {
        case automatic
        case plain
        case inset
        case insetGrouped
        case sidebar
        case grouped
        case bordered
    }
    
    let style: Style
    
    init(_ style: Style) {
        self.style = style
    }
}

extension AnyListStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic":
                self.style = .automatic
            case "plain":
                self.style = .plain
            case "inset":
                self.style = .inset
            case "insetGrouped":
                self.style = .insetGrouped
            case "sidebar":
                self.style = .sidebar
            case "grouped":
                self.style = .grouped
            case "bordered":
                self.style = .bordered
            default:
                return nil
            }
            return
        }
        return nil
    }
}

// MARK: - AnyTableStyle

#if os(iOS) || os(macOS) || os(visionOS)
/// Type-erased table style for runtime parsing.
@available(iOS 16.0, macOS 12.0, visionOS 1.0, *)
public struct AnyTableStyle: @unchecked Sendable {
    enum Style {
        case automatic
        case inset
        #if os(macOS)
        case bordered
        #endif
    }
    
    let style: Style
    
    init(_ style: Style) {
        self.style = style
    }
}

@available(iOS 16.0, macOS 12.0, visionOS 1.0, *)
extension AnyTableStyle: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic":
                self.style = .automatic
            case "inset":
                self.style = .inset
            #if os(macOS)
            case "bordered":
                self.style = .bordered
            #endif
            default:
                return nil
            }
            return
        }
        return nil
    }
}
#endif

// MARK: - VerticalEdge.Set

extension VerticalEdge.Set: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "all":
                self = .all
            case "top":
                self = .top
            case "bottom":
                self = .bottom
            default:
                return nil
            }
            return
        }
        
        // Handle array syntax like [.top, .bottom]
        if let arrayExpr = syntax.as(ArrayExprSyntax.self) {
            var combined = VerticalEdge.Set()
            for element in arrayExpr.elements {
                if let edge = VerticalEdge.Set(syntax: element.expression) {
                    combined.insert(edge)
                } else {
                    return nil
                }
            }
            self = combined
            return
        }
        
        return nil
    }
}
