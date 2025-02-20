//
//  DisclosureGroupStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/4/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("DisclosureGroupStyle")
enum StylesheetResolvableDisclosureGroupStyle: @preconcurrency DisclosureGroupStyle, StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
    case automatic
}

extension StylesheetResolvableDisclosureGroupStyle {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
    
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.DisclosureGroup(isExpanded: configuration.$isExpanded) {
                configuration.content
            } label: {
                configuration.label
            }.disclosureGroupStyle(.automatic)
        }
    }
}
