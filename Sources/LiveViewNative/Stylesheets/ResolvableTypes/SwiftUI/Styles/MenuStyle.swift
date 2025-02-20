//
//  MenuStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("MenuStyle")
enum StylesheetResolvableMenuStyle: @preconcurrency MenuStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    case button
}

extension StylesheetResolvableMenuStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.Menu(configuration).menuStyle(.automatic)
        case .button:
            SwiftUI.Menu(configuration).menuStyle(.button)
        }
    }
}

extension StylesheetResolvableMenuStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "button":
            self = .button
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
