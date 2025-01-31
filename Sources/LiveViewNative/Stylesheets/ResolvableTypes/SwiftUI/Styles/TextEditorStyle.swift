//
//  TextEditorStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

#if os(iOS) || os(macOS) || os(visionOS)
@ASTDecodable("TextEditorStyle")
@available(iOS 17, macOS 14, *)
enum StylesheetResolvableTextEditorStyle: TextEditorStyle, StylesheetResolvable {
    case automatic
    case plain
    #if os(visionOS)
    case roundedBorder
    #endif
}

@available(iOS 17, macOS 14, *)
extension StylesheetResolvableTextEditorStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            AutomaticTextEditorStyle.automatic.makeBody(configuration: configuration)
        case .plain:
            PlainTextEditorStyle.plain.makeBody(configuration: configuration)
        #if os(visionOS)
        case .roundedBorder:
            RoundedBorderTextEditorStyle.roundedBorder.makeBody(configuration: configuration)
        #endif
        }
    }
}

@available(iOS 17, macOS 14, *)
extension StylesheetResolvableTextEditorStyle: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "plain":
            self = .plain
        #if os(visionOS)
        case "roundedBorder":
            self = .roundedBorder
        #endif
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
#endif
