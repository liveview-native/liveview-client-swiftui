//
//  ButtonStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("PrimitiveButtonStyle")
enum StylesheetResolvablePrimitiveButtonStyle: PrimitiveButtonStyle, StylesheetResolvable {
    case automatic
    #if os(macOS)
    case accessoryBar
    case accessoryBarAction
    #endif
    case bordered
    case borderedProminent
    case borderless
    #if os(tvOS)
    case card
    #endif
    #if os(macOS)
    case link
    #endif
    case plain
}

extension StylesheetResolvablePrimitiveButtonStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.Button(configuration).buttonStyle(.automatic)
        #if os(macOS)
        case .accessoryBar:
            if #available(macOS 14, *) {
                SwiftUI.Button(configuration).buttonStyle(.accessoryBar)
            } else {
                SwiftUI.Button(configuration)
            }
        case .accessoryBarAction:
            if #available(macOS 14, *) {
                SwiftUI.Button(configuration).buttonStyle(.accessoryBarAction)
            }
        #endif
        case .bordered:
            SwiftUI.Button(configuration).buttonStyle(.bordered)
        case .borderedProminent:
            SwiftUI.Button(configuration).buttonStyle(.borderedProminent)
        case .borderless:
            SwiftUI.Button(configuration).buttonStyle(.borderless)
        #if os(tvOS)
        case .card:
            SwiftUI.Button(configuration).buttonStyle(.card)
        #endif
        #if os(macOS)
        case .link:
            SwiftUI.Button(configuration).buttonStyle(.link)
        #endif
        case .plain:
            SwiftUI.Button(configuration).buttonStyle(.plain)
        }
    }
}

extension StylesheetResolvablePrimitiveButtonStyle: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        #if os(macOS)
        case "accessoryBar":
            self = .accessoryBar
        case "accessoryBarAction":
            self = .accessoryBarAction
        #endif
        case "bordered":
            self = .bordered
        case "borderedProminent":
            self = .borderedProminent
        case "borderless":
            self = .borderless
        #if os(tvOS)
        case "card":
            self = .card
        #endif
        #if os(macOS)
        case "link":
            self = .link
        #endif
        case "plain":
            self = .plain
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@ASTDecodable("ButtonStyle")
enum StylesheetResolvableButtonStyle: ButtonStyle, StylesheetResolvable, AttributeDecodable {
    case __never
}

extension StylesheetResolvableButtonStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        fatalError()
    }
    
    func makeBody(configuration: Configuration) -> some View {
        fatalError()
    }
    
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
