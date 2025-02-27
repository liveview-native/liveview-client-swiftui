//
//  LabelStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("LabelStyle")
enum StylesheetResolvableLabelStyle: @preconcurrency LabelStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    case iconOnly
    case titleAndIcon
    case titleOnly
}

extension StylesheetResolvableLabelStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.Label(configuration).labelStyle(.automatic)
        case .iconOnly:
            SwiftUI.Label(configuration).labelStyle(.iconOnly)
        case .titleAndIcon:
            SwiftUI.Label(configuration).labelStyle(.titleAndIcon)
        case .titleOnly:
            SwiftUI.Label(configuration).labelStyle(.titleOnly)
        }
    }
}

extension StylesheetResolvableLabelStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "iconOnly":
            self = .iconOnly
        case "titleAndIcon":
            self = .titleAndIcon
        case "titleOnly":
            self = .titleOnly
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
