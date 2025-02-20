//
//  GroupBoxStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("GroupBoxStyle")
enum StylesheetResolvableGroupBoxStyle: @preconcurrency GroupBoxStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
}

extension StylesheetResolvableGroupBoxStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.GroupBox(configuration).groupBoxStyle(.automatic)
        }
    }
}

extension StylesheetResolvableGroupBoxStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
