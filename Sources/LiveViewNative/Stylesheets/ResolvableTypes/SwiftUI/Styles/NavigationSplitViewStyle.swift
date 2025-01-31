//
//  NavigationSplitViewStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("NavigationSplitViewStyle")
enum StylesheetResolvableNavigationSplitViewStyle: NavigationSplitViewStyle, StylesheetResolvable {
    case automatic
    case balanced
    case prominentDetail
}

extension StylesheetResolvableNavigationSplitViewStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            AutomaticNavigationSplitViewStyle().makeBody(configuration: configuration)
        case .balanced:
            BalancedNavigationSplitViewStyle().makeBody(configuration: configuration)
        case .prominentDetail:
            ProminentDetailNavigationSplitViewStyle().makeBody(configuration: configuration)
        }
    }
}

extension StylesheetResolvableNavigationSplitViewStyle: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "balanced":
            self = .balanced
        case "prominentDetail":
            self = .prominentDetail
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
