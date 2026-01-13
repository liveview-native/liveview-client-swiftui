import SwiftUI
import SwiftSyntax

// MARK: - ScrollIndicatorVisibility

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ScrollIndicatorVisibility: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }
        
        switch memberAccess.declName.baseName.text {
        case "automatic":
            self = .automatic
        case "visible":
            self = .visible
        case "hidden":
            self = .hidden
        case "never":
            self = .never
        default:
            return nil
        }
    }
}

// MARK: - ScrollDismissesKeyboardMode

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ScrollDismissesKeyboardMode: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }
        
        switch memberAccess.declName.baseName.text {
        case "automatic":
            self = .automatic
        case "immediately":
            self = .immediately
        case "interactively":
            self = .interactively
        case "never":
            self = .never
        default:
            return nil
        }
    }
}

// MARK: - ScrollTargetBehavior wrapper

/// A type-erased scroll target behavior for use in modifiers
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct AnyScrollTargetBehavior: ScrollTargetBehavior, SyntaxConvertible {
    private let _updateTarget: (inout ScrollTarget, ScrollTargetBehaviorContext) -> Void
    
    public init<T: ScrollTargetBehavior>(_ behavior: T) {
        self._updateTarget = behavior.updateTarget
    }
    
    public func updateTarget(_ target: inout ScrollTarget, context: ScrollTargetBehaviorContext) {
        _updateTarget(&target, context)
    }
    
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }
        
        switch memberAccess.declName.baseName.text {
        case "paging":
            self.init(PagingScrollTargetBehavior())
        case "viewAligned":
            self.init(ViewAlignedScrollTargetBehavior())
        default:
            return nil
        }
    }
}
