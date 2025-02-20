//
//  WindowToolbarStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/20/25.
//

#if os(macOS)
import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("WindowToolbarStyle")
enum StylesheetResolvableWindowToolbarStyle: StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
    case automatic
    case expanded
    case unified
    
    case _unified(showsTitle: AttributeReference<Bool>)
    case _unifiedResolved(showsTitle: Bool)
    static func unified(showsTitle: AttributeReference<Bool>) -> Self {
        ._unified(showsTitle: showsTitle)
    }
    
    case unifiedCompact
    
    case _unifiedCompact(showsTitle: AttributeReference<Bool>)
    case _unifiedCompactResolved(showsTitle: Bool)
    static func unifiedCompact(showsTitle: AttributeReference<Bool>) -> Self {
        ._unifiedCompact(showsTitle: showsTitle)
    }
}

extension StylesheetResolvableWindowToolbarStyle {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "expanded":
            self = .expanded
        case "unified":
            self = .unified
        case "unifiedCompact":
            self = .unifiedCompact
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        switch self {
        case .automatic:
            return self
        case .expanded:
            return self
        case .unified:
            return self
        case ._unified(let showsTitle):
            return ._unifiedResolved(showsTitle: showsTitle.resolve(on: element, in: context))
        case ._unifiedResolved:
            return self
        case .unifiedCompact:
            return self
        case ._unifiedCompact(let showsTitle):
            return ._unifiedCompactResolved(showsTitle: showsTitle.resolve(on: element, in: context))
        case ._unifiedCompactResolved:
            return self
        }
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func presentedWindowToolbarStyle(_ style: StylesheetResolvableWindowToolbarStyle) -> some View {
        switch style {
        case .automatic:
            self.presentedWindowToolbarStyle(DefaultWindowToolbarStyle.automatic)
        case .expanded:
            self.presentedWindowToolbarStyle(ExpandedWindowToolbarStyle.expanded)
        case .unified:
            self.presentedWindowToolbarStyle(UnifiedWindowToolbarStyle.unified)
        case ._unified:
            fatalError()
        case ._unifiedResolved(let showsTitle):
            self.presentedWindowToolbarStyle(UnifiedWindowToolbarStyle.unified(showsTitle: showsTitle))
        case .unifiedCompact:
            self.presentedWindowToolbarStyle(UnifiedCompactWindowToolbarStyle.unifiedCompact)
        case ._unifiedCompact:
            fatalError()
        case ._unifiedCompactResolved(let showsTitle):
            self.presentedWindowToolbarStyle(UnifiedCompactWindowToolbarStyle.unifiedCompact(showsTitle: showsTitle))
        }
    }
}
#endif
