//
//  FormStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("FormStyle")
enum StylesheetResolvableFormStyle: @preconcurrency FormStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    case columns
    case grouped
}

extension StylesheetResolvableFormStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.Form(configuration).formStyle(.automatic)
        case .columns:
            SwiftUI.Form(configuration).formStyle(.columns)
        case .grouped:
            SwiftUI.Form(configuration).formStyle(.grouped)
        }
    }
}

extension StylesheetResolvableFormStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "columns":
            self = .columns
        case "grouped":
            self = .grouped
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
