//
//  TextSelectability.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("TextSelectability")
enum StylesheetResolvableTextSelectability: StylesheetResolvable, @preconcurrency Decodable {
    case enabled
    case disabled
}

extension StylesheetResolvableTextSelectability {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    nonisolated func textSelection(_ selectability: StylesheetResolvableTextSelectability) -> some View {
        switch selectability {
        case .enabled:
            self.textSelection(EnabledTextSelectability.enabled)
        case .disabled:
            self.textSelection(DisabledTextSelectability.disabled)
        }
    }
}

extension StylesheetResolvableTextSelectability: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "enabled":
            self = .enabled
        case "disabled":
            self = .disabled
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
