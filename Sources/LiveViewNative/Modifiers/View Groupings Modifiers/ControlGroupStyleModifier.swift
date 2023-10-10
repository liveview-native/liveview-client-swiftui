//
//  ControlGroupStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/2/2023.
//

import SwiftUI

/// Alters the visual style of any control groups within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``ControlGroupStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
struct ControlGroupStyleModifier: ViewModifier, Decodable {
    /// The style to apply to control groups.
    @_documentation(visibility: public)
    private let style: ControlGroupStyle
    
    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        switch style {
        case .automatic:
            content.controlGroupStyle(.automatic)
        case .compactMenu:
            if #available(iOS 16.4, macOS 13.3, *) {
                content.controlGroupStyle(.compactMenu)
            } else {
                content
            }
        case .menu:
            if #available(iOS 16.4, macOS 13.3, *) {
                content.controlGroupStyle(.menu)
            } else {
                content
            }
        case .navigation:
            content.controlGroupStyle(.navigation)
        }
        #else
        content
        #endif
    }
}
#else
struct ControlGroupStyleModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        content
    }
}
#endif

/// A style for a ``ControlGroup`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
fileprivate enum ControlGroupStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    /// `compact_menu`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.4, macOS 13.3, *)
    case compactMenu = "compact_menu"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.4, macOS 13.3, *)
    case menu
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case navigation
}
#endif
