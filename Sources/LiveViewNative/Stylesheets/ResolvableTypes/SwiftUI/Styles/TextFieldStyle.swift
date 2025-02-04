//
//  TextFieldStyle.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("TextFieldStyle")
enum StylesheetResolvableTextFieldStyle: StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    case plain
    case roundedBorder
    #if os(macOS)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case squareBorder
    #endif
}

extension StylesheetResolvableTextFieldStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func textFieldStyle(_ style: StylesheetResolvableTextFieldStyle) -> some View {
        switch style {
        case .automatic:
            self.textFieldStyle(.automatic)
        case .plain:
            self.textFieldStyle(.plain)
        case .roundedBorder:
            self.textFieldStyle(.roundedBorder)
        #if os(macOS)
        case .squareBorder:
            self.textFieldStyle(.squareBorder)
        #endif
        }
    }
}

extension StylesheetResolvableTextFieldStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "plain":
            self = .plain
        case "roundedBorder":
            self = .roundedBorder
        #if os(macOS)
        case "squareBorder":
            self = .squareBorder
        #endif
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
