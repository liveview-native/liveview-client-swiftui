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
///     <Text #label>Transportation</Text>
///     <Group #content>
///         <Label system-image="car" modifiers={tag(@native, tag: "car")}>Car</Label>
///         <Label system-image="bus" modifiers={tag(@native, tag: "bus")}>Bus</Label>
///         <Label system-image="tram" modifiers={tag(@native, tag: "tram")}>Tram</Label>
///     </Group>
/// </Picker>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.PickerLive do
///     native_binding :transport, String, "tram"
/// end
/// ```
///
/// ## Children
/// - `content`
/// - `label`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Picker<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @ObservedElement private var element
    @FormState private var value: String?
    
    var body: some View {
        SwiftUI.Picker(selection: $value) {
            context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: false)
        } label: {
            context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: false)
        }
    }
    
}
