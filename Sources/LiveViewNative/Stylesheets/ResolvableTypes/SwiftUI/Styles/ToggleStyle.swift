//
//  ToggleStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("ToggleStyle")
enum StylesheetResolvableToggleStyle: ToggleStyle, StylesheetResolvable {
    case automatic
    case button
    #if os(macOS)
    case checkbox
    #endif
    case `switch`
}

extension StylesheetResolvableToggleStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.Toggle(configuration).toggleStyle(.automatic)
        case .button:
            SwiftUI.Toggle(configuration).toggleStyle(.button)
        #if os(macOS)
        case .checkbox:
            SwiftUI.Toggle(configuration).toggleStyle(.checkbox)
        #endif
        case .switch:
            SwiftUI.Toggle(configuration).toggleStyle(.switch)
        }
    }
}

extension StylesheetResolvableToggleStyle: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "button":
            self = .button
        #if os(macOS)
        case "checkbox":
            self = .checkbox
        #endif
        case "switch":
            self = .switch
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
