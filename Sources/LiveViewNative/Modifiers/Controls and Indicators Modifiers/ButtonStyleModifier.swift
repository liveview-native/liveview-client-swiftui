//
//  ButtonStyleModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/4/23.
//

import SwiftUI

/// Alters the visual style of any buttons within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``ButtonStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ButtonStyleModifier: ViewModifier, Decodable {
    /// The style to apply to buttons.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: ButtonStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .automatic:
            content.buttonStyle(.automatic)
        case .bordered:
            content.buttonStyle(.bordered)
        case .borderedProminent:
            content.buttonStyle(.borderedProminent)
        case .borderless:
            if #available(iOS 13.0, macOS 10.15, tvOS 17.0, watchOS 8.0, *) {
                content.buttonStyle(.borderless)
            } else {
                content
            }
        case .plain:
            content.buttonStyle(.plain)
        }
    }
}

/// A style for the ``Button`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum ButtonStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case bordered
    /// `bordered_prominent`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case borderedProminent = "bordered_prominent"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case borderless
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case plain
}
