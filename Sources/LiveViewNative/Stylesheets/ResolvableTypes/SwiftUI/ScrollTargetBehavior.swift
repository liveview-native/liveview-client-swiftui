//
//  StylesheetResolvableScrollTargetBehavior.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("ScrollTargetBehavior")
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
enum StylesheetResolvableScrollTargetBehavior: ScrollTargetBehavior, StylesheetResolvable {
    case _resolved(any ScrollTargetBehavior)
    
    case paging
    case viewAligned
    case _viewAligned(limitBehavior: Any)
    
    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
    static func viewAligned(limitBehavior: AttributeReference<ViewAlignedScrollTargetBehavior.LimitBehavior.Resolvable>) -> Self {
        ._viewAligned(limitBehavior: limitBehavior)
    }
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        guard case let ._resolved(resolved) = self
        else { fatalError() }
        
        resolved.updateTarget(&target, context: context)
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension ViewAlignedScrollTargetBehavior.LimitBehavior.Resolvable: AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "always":
            self = .always
        case "alwaysByFew":
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self = .alwaysByFew
            } else {
                self = .automatic
            }
        case "alwaysByOne":
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                self = .alwaysByOne
            } else {
                self = .automatic
            }
        case "never":
            self = .never
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension StylesheetResolvableScrollTargetBehavior {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        switch self {
        case .paging:
            return ._resolved(.paging)
        case .viewAligned:
            return ._resolved(.viewAligned)
        case ._viewAligned(let limitBehavior):
            return ._resolved(.viewAligned(
                limitBehavior: (limitBehavior as! AttributeReference<ViewAlignedScrollTargetBehavior.LimitBehavior.Resolvable>)
                    .resolve(on: element, in: context)
                    .resolve(on: element, in: context)
            ))
        case ._resolved:
            return self
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension StylesheetResolvableScrollTargetBehavior: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "paging":
            self = .paging
        case "viewAligned":
            self = .viewAligned
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
