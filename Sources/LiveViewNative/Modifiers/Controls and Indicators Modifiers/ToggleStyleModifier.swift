//
//  ToggleStyle.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/4/23.
//

import SwiftUI

/// Alters the visual style of any toggles within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``ToggleStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToggleStyleModifier: ViewModifier, Decodable {
    /// The style to apply to toggles.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: ToggleStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .automatic:
            content.toggleStyle(.automatic)
        case .button:
            #if os(tvOS)
            content
            #else
            content.toggleStyle(.button)
            #endif
        case .`switch`:
            #if os(tvOS)
            content
            #else
            content.toggleStyle(.switch)
            #endif
        case .checkbox:
            #if os(macOS)
            content.toggleStyle(.checkbox)
            #else
            content
            #endif
        }
    }
}

/// The visual style of a ``Toggle``.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum ToggleStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case button
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case `switch`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case checkbox
}
