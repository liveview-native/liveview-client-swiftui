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
enum StylesheetResolvableToggleStyle: @preconcurrency ToggleStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
    @available(tvOS, unavailable)
    case button
    #endif
    #if os(macOS)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
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
        #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
        case .button:
            SwiftUI.Toggle(configuration).toggleStyle(.button)
            #endif
        #if os(macOS)
        case .checkbox:
            SwiftUI.Toggle(configuration).toggleStyle(.checkbox)
        #endif
        case .switch:
            if #available(iOS 13.0, macOS 10.15, tvOS 18.0, watchOS 6.0, *) {
                SwiftUI.Toggle(configuration).toggleStyle(.switch)
            } else {
                SwiftUI.Toggle(configuration).toggleStyle(.automatic)
            }
        }
    }
}

extension StylesheetResolvableToggleStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
        case "button":
            self = .button
        #endif
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
