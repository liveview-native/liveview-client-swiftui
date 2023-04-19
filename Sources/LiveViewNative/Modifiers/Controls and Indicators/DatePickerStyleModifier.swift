//
//  DatePickerStyleModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/4/23.
//

import SwiftUI

/// Alters the visual style of any date pickers within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``DatePickerStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct DatePickerStyleModifier: ViewModifier, Decodable {
    /// The style to apply to date pickers.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: DatePickerStyle
    
    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        switch style {
        case .automatic:
            content.datePickerStyle(.automatic)
        case .compact:
            content.datePickerStyle(.compact)
        case .graphical:
            content.datePickerStyle(.graphical)
        case .wheel:
#if os(iOS)
            content.datePickerStyle(.wheel)
#endif
        case .field:
#if os(macOS)
            content.datePickerStyle(.field)
#endif
        case .stepperField:
#if os(macOS)
            content.datePickerStyle(.stepperField)
#endif
        }
        #else
        content
        #endif
    }
}

/// The style of a ``DatePicker``.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum DatePickerStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 13.0, *)
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 13.0, *)
    case compact
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 13.0, *)
    case graphical
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, *)
    case wheel
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case field
    /// `stepper_field`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case stepperField = "stepper_field"
}
