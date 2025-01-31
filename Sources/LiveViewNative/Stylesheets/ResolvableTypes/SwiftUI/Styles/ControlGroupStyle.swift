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
enum StylesheetResolvableControlGroupStyle: ControlGroupStyle, StylesheetResolvable {
    case automatic
    case compactMenu
    case menu
    case navigation
    case palette
}

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
            if #available(iOS 16.4, macOS 13.3, *) {
                SwiftUI.ControlGroup(configuration).controlGroupStyle(.compactMenu)
            }
        case .menu:
            if #available(iOS 16.4, macOS 13.3, *) {
                SwiftUI.ControlGroup(configuration).controlGroupStyle(.menu)
            }
        case .navigation:
            SwiftUI.ControlGroup(configuration).controlGroupStyle(.navigation)
        case .palette:
            if #available(iOS 17, macOS 14, *) {
                SwiftUI.ControlGroup(configuration).controlGroupStyle(.palette)
            }
        }
    }
}

extension StylesheetResolvableControlGroupStyle: AttributeDecodable {
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
