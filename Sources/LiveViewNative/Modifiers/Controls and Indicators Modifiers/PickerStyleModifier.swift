//
//  PickerStyleModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/4/23.
//

import SwiftUI

/// Alters the visual style of any pickers within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``PickerStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PickerStyleModifier: ViewModifier, Decodable {
    /// The style to apply to pickers.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: PickerStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .automatic:
            content.pickerStyle(.automatic)
        case .inline:
            content.pickerStyle(.inline)
        case .menu:
#if os(iOS) || os(macOS)
            content.pickerStyle(.menu)
#endif
        case .navigationLink:
#if !os(macOS)
            content.pickerStyle(.navigationLink)
#endif
        case .radioGroup:
#if os(macOS)
            content.pickerStyle(.radioGroup)
#endif
        case .segmented:
#if !os(watchOS)
            content.pickerStyle(.segmented)
#endif
        case .wheel:
#if os(iOS) || os(watchOS)
            content.pickerStyle(.wheel)
#endif
        }
    }
}

/// The visual style of a ``Picker`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum PickerStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    case inline
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, macOS 13.0, *)
    case menu
    /// `navigation_link`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    case navigationLink = "navigation_link"
    /// `radio_group`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case radioGroup = "radio_group"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, macOS 13.0, *)
    case segmented
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, watchOS 9.0, *)
    case wheel
}
