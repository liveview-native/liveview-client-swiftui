import SwiftUI
import SwiftSyntax

// MARK: - ToolbarPlacement

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ToolbarPlacement: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Parse member access like .automatic, .navigationBar, .bottomBar, etc.
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic":
                self = .automatic
            #if !os(macOS) && !os(tvOS)
            case "bottomBar":
                if #available(watchOS 10.0, *) {
                    self = .bottomBar
                } else {
                    return nil
                }
            #endif
            #if !os(macOS)
            case "navigationBar":
                self = .navigationBar
            #endif
            #if !os(macOS) && !os(watchOS)
            case "tabBar":
                self = .tabBar
            #endif
            default:
                return nil
            }
            return
        }
        return nil
    }
}

// MARK: - ToolbarRole

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ToolbarRole: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic":
                self = .automatic
            #if canImport(UIKit) && !os(watchOS)
            case "navigationStack":
                self = .navigationStack
            case "browser":
                self = .browser
            #endif
            case "editor":
                self = .editor
            default:
                return nil
            }
            return
        }
        return nil
    }
}

// MARK: - ToolbarTitleDisplayMode

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ToolbarTitleDisplayMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic":
                self = .automatic
            case "inline":
                self = .inline
            case "inlineLarge":
                self = .inlineLarge
            #if canImport(UIKit)
            case "large":
                self = .large
            #endif
            default:
                return nil
            }
            return
        }
        return nil
    }
}

// MARK: - Visibility

extension Visibility: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "automatic":
                self = .automatic
            case "visible":
                self = .visible
            case "hidden":
                self = .hidden
            default:
                return nil
            }
            return
        }
        return nil
    }
}

// MARK: - ContentToolbarPlacement

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension ContentToolbarPlacement: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "tabViewSidebar":
                self = .tabViewSidebar
            default:
                return nil
            }
            return
        }
        return nil
    }
}
#endif

// MARK: - ColorScheme

extension ColorScheme: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self) {
            let name = memberAccess.declName.baseName.text
            switch name {
            case "light":
                self = .light
            case "dark":
                self = .dark
            default:
                return nil
            }
            return
        }
        return nil
    }
}
