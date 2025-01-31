//
//  TableStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("TableStyle")
enum StylesheetResolvableTableStyle: TableStyle, StylesheetResolvable {
    case automatic
    case inset
    #if os(macOS)
    case bordered
    #endif
}

extension StylesheetResolvableTableStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            AutomaticTableStyle.automatic.makeBody(configuration: configuration)
        case .inset:
            InsetTableStyle.inset.makeBody(configuration: configuration)
        #if os(macOS)
        case .bordered:
            BorderedTableStyle.bordered.makeBody(configuration: configuration)
        #endif
        }
    }
}

extension StylesheetResolvableTableStyle: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "inset":
            self = .inset
        #if os(macOS)
        case "bordered":
            self = .bordered
        #endif
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
