//
//  Picker.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/8/23.
//

import SwiftUI

/// A control that picks one of multiple values.
///
/// The value of a picker is the value of the ``TagModifier`` for the selected option.
///
/// Use the `content` children to specify the options for the picker, and the `label` children to provide a label.
///
/// ```html
/// <Picker value-binding="transport" picker-style="menu">
///     <Picker:content>
///         <Label system-image="car" modifiers={tag(@native, tag: "car")}>Car</Label>
///         <Label system-image="bus" modifiers={tag(@native, tag: "bus")}>Bus</Label>
///         <Label system-image="tram" modifiers={tag(@native, tag: "tram")}>Tram</Label>
///     </Picker:content>
///     <Picker:label>
///         <Text>Transportation</Text>
///     </Picker:label>
/// </Picker>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.PickerLive do
///     native_binding :transport, String, "tram"
/// end
/// ```
///
/// ## Attributes
/// - ``style``
///
/// ## Children
/// - `content`
/// - `label`
///
/// ## Topics
/// ### Supporting Types
/// - ``PickerStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Picker<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @ObservedElement private var element
    @FormState private var value: String?
    /// The visual style of this picker.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("picker-style") private var style: PickerStyle = .automatic
    
    var body: some View {
        SwiftUI.Picker(selection: $value) {
            context.buildChildren(of: element, withTagName: "content", namespace: "Picker", includeDefaultSlot: false)
        } label: {
            context.buildChildren(of: element, withTagName: "label", namespace: "Picker", includeDefaultSlot: false)
        }
        .applyPickerStyle(style)
    }
    
}

/// The visual style of a ``Picker`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum PickerStyle: String, AttributeDecodable {
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
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    case navigationLink = "navigation-link"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case radioGroup = "radio-group"
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

private extension View {
    @ViewBuilder
    func applyPickerStyle(_ style: PickerStyle) -> some View {
        switch style {
        case .automatic:
            self.pickerStyle(.automatic)
        case .inline:
            self.pickerStyle(.inline)
        case .menu:
#if os(iOS) || os(macOS)
            self.pickerStyle(.menu)
#endif
        case .navigationLink:
#if !os(macOS)
            self.pickerStyle(.navigationLink)
#endif
        case .radioGroup:
#if os(macOS)
            self.pickerStyle(.radioGroup)
#endif
        case .segmented:
#if !os(watchOS)
            self.pickerStyle(.segmented)
#endif
        case .wheel:
#if os(iOS) || os(watchOS)
            self.pickerStyle(.wheel)
#endif
        }
    }
}
