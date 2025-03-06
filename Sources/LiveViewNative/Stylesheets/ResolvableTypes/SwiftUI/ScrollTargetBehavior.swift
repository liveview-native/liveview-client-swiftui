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
enum StylesheetResolvableScrollTargetBehavior: StylesheetResolvable, @preconcurrency Decodable {
    case paging
    case viewAligned
    case _viewAligned(limitBehavior: Any)
    case _viewAlignedResolved(limitBehavior: Any)
    
    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
    static func viewAligned(limitBehavior: AttributeReference<ViewAlignedScrollTargetBehavior.LimitBehavior.Resolvable>) -> Self {
        ._viewAligned(limitBehavior: limitBehavior)
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension ViewAlignedScrollTargetBehavior.LimitBehavior.Resolvable: @preconcurrency AttributeDecodable {
    public init(from attribute: Attribute?, on element: ElementNode) throws {
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
            return self
        case .viewAligned:
            return self
        case ._viewAligned(let limitBehavior):
            return ._viewAlignedResolved(
                limitBehavior: (limitBehavior as! AttributeReference<ViewAlignedScrollTargetBehavior.LimitBehavior.Resolvable>)
                    .resolve(on: element, in: context)
                    .resolve(on: element, in: context)
            )
        case ._viewAlignedResolved:
            return self
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension StylesheetResolvableScrollTargetBehavior: @preconcurrency AttributeDecodable {
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

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension View {
    @_disfavoredOverload
    @ViewBuilder
    func scrollTargetBehavior(_ behavior: StylesheetResolvableScrollTargetBehavior) -> some View {
        switch behavior {
        case .paging:
            self.scrollTargetBehavior(.paging)
        case .viewAligned:
            self.scrollTargetBehavior(.viewAligned)
        case ._viewAligned:
            fatalError()
        case ._viewAlignedResolved(let limitBehavior):
            self.scrollTargetBehavior(.viewAligned(limitBehavior: limitBehavior as! ViewAlignedScrollTargetBehavior.LimitBehavior))
        }
    }
}
