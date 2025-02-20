//
//  LabeledContentStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("LabeledContentStyle")
enum StylesheetResolvableLabeledContentStyle: @preconcurrency LabeledContentStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
}

extension StylesheetResolvableLabeledContentStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.LabeledContent(configuration).labeledContentStyle(.automatic)
        }
    }
}

extension StylesheetResolvableLabeledContentStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
