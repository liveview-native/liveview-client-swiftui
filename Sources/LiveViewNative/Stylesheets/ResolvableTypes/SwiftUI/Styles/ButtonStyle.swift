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
enum StylesheetResolvablePrimitiveButtonStyle: @preconcurrency PrimitiveButtonStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    #if os(macOS)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case accessoryBar
    
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case accessoryBarAction
    #endif
    case bordered
    case borderedProminent
    case borderless
    #if os(tvOS)
    @available(iOS, unavailable)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case card
    #endif
    #if os(macOS)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    case link
    #endif
    case plain
    
    case glass
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
            if #available(iOS 13.0, macOS 10.15, tvOS 17.0, watchOS 8.0, *) {
                SwiftUI.Button(configuration).buttonStyle(.borderless)
            } else {
                SwiftUI.Button(configuration).buttonStyle(.automatic)
            }
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
        case .glass:
            if #available(iOS 26, macOS 26, tvOS 26, visionOS 26, watchOS 26, *) {
                SwiftUI.Button(configuration).buttonStyle(.glass)
            } else {
                SwiftUI.Button(configuration).buttonStyle(.automatic)
            }
        }
    }
}

extension StylesheetResolvablePrimitiveButtonStyle: @preconcurrency AttributeDecodable {
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
        case "glass":
            self = .glass
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@ASTDecodable("ButtonStyle")
enum StylesheetResolvableButtonStyle: @preconcurrency ButtonStyle, StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
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
