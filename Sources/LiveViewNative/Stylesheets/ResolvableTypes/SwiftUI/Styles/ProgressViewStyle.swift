//
//  ProgressViewStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("ProgressViewStyle")
enum StylesheetResolvableProgressViewStyle: @preconcurrency ProgressViewStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    case circular
    case linear
}

extension StylesheetResolvableProgressViewStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.ProgressView(configuration).progressViewStyle(.automatic)
        case .circular:
            SwiftUI.ProgressView(configuration).progressViewStyle(.circular)
        case .linear:
            SwiftUI.ProgressView(configuration).progressViewStyle(.linear)
        }
    }
}

extension StylesheetResolvableProgressViewStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "circular":
            self = .circular
        case "linear":
            self = .linear
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
