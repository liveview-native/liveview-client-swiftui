//
//  ListStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/12/2023.
//

import SwiftUI

/// Sets the style of a ``List``.
///
/// See ``ListStyle`` for a list of possible values.
///
/// ```html
/// <List modifiers={list_style(:inset_grouped)}>
///     ...
/// </List>
/// ```
///
/// ## Arguments
/// * ``style``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ListStyleModifier: ViewModifier, Decodable {
    /// The style to apply to the list.
    ///
    /// See ``ListStyle`` for the list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: ListStyle

    func body(content: Content) -> some View {
        switch style {
        case .automatic:
            content.listStyle(.automatic)
        case .bordered:
            #if os(macOS)
            content.listStyle(.bordered(alternatesRowBackgrounds: false))
            #endif
        case .borderedAlternating:
            #if os(macOS)
            content.listStyle(.bordered(alternatesRowBackgrounds: true))
            #endif
        case .carousel:
            #if os(watchOS)
            content.listStyle(.carousel)
            #endif
        case .elliptical:
            #if os(watchOS)
            content.listStyle(.elliptical)
            #endif
        case .grouped:
            #if os(iOS) || os(tvOS)
            content.listStyle(.grouped)
            #endif
        case .inset:
            #if os(iOS) || os(macOS)
            content.listStyle(.inset)
            #endif
        case .insetGrouped:
            #if os(iOS)
            content.listStyle(.insetGrouped)
            #endif
        case .insetAlternating:
            #if os(macOS)
            content.listStyle(.inset(alternatesRowBackgrounds: true))
            #endif
        case .plain:
            content.listStyle(.plain)
        case .sidebar:
            #if os(iOS) || os(macOS)
            content.listStyle(.sidebar)
            #endif
        }
    }
}

/// A style to apply to a list with the ``ListStyleModifier`` modifier.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum ListStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case bordered
    /// `bordered_alternating`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case borderedAlternating = "bordered_alternating"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(watchOS 9.0, *)
    case carousel
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(watchOS 9.0, *)
    case elliptical
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, *)
    case grouped
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, macOS 13.0, *)
    case inset
    /// `inset_grouped`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, *)
    case insetGrouped = "inset_grouped"
    /// `inset_alternating`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case insetAlternating = "inset_alternating"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case plain
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, macOS 13.0, *)
    case sidebar
}
