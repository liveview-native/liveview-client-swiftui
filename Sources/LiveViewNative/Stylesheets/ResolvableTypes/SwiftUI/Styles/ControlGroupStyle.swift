//
//  ControlGroupStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("ControlGroupStyle")
@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
enum StylesheetResolvableControlGroupStyle: @preconcurrency ControlGroupStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    case compactMenu
    case menu
    case navigation
    case palette
}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
extension StylesheetResolvableControlGroupStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            SwiftUI.ControlGroup(configuration).controlGroupStyle(.automatic)
        case .compactMenu:
            #if os(iOS) || os(macOS) || os(visionOS)
            if #available(iOS 16.4, macOS 13.3, *) {
                SwiftUI.ControlGroup(configuration).controlGroupStyle(.compactMenu)
            }
            #endif
        case .menu:
            if #available(iOS 16.4, macOS 13.3, *) {
                SwiftUI.ControlGroup(configuration).controlGroupStyle(.menu)
            }
        case .navigation:
            #if os(iOS) || os(macOS) || os(visionOS)
            SwiftUI.ControlGroup(configuration).controlGroupStyle(.navigation)
            #endif
        case .palette:
            #if os(iOS) || os(macOS) || os(visionOS)
            if #available(iOS 17, macOS 14, *) {
                SwiftUI.ControlGroup(configuration).controlGroupStyle(.palette)
            }
            #endif
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
extension StylesheetResolvableControlGroupStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "compactMenu":
            self = .compactMenu
        case "menu":
            self = .menu
        case "navigation":
            self = .navigation
        case "palette":
            self = .palette
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
