//
//  NavigationTransition.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/4/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("NavigationTransition")
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
enum StylesheetResolvableNavigationTransition: StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    
    case _zoom(sourceID: AttributeReference<String>, namespace: Namespace.ID.Resolvable)
    case _zoomResolved(sourceID: String, namespace: Namespace.ID)
    static func zoom(sourceID: AttributeReference<String>, in namespace: Namespace.ID.Resolvable) -> Self {
        return ._zoom(sourceID: sourceID, namespace: namespace)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension StylesheetResolvableNavigationTransition: @preconcurrency AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension StylesheetResolvableNavigationTransition {
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        switch self {
        case .automatic:
            return self
        case let ._zoom(sourceID, namespace):
            return ._zoomResolved(
                sourceID: sourceID.resolve(on: element, in: context),
                namespace: namespace.resolve(on: element, in: context)
            )
        case ._zoomResolved:
            return self
        }
    }
}

extension View {
    @_disfavoredOverload
    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    @ViewBuilder
    func navigationTransition(_ style: StylesheetResolvableNavigationTransition) -> some View {
        switch style {
        case .automatic:
            self.navigationTransition(AutomaticNavigationTransition.automatic)
        case ._zoom(let sourceID, let namespace):
            fatalError()
        case ._zoomResolved(let sourceID, let namespace):
            self.navigationTransition(ZoomNavigationTransition.zoom(sourceID: sourceID, in: namespace))
        }
    }
}
