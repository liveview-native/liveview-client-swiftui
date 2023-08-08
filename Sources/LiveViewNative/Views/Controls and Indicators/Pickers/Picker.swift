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
/// <Picker selection={@transport} phx-change="transport-changed">
///     <Text template={:label}>Transportation</Text>
///     <Group template={:content}>
///         <Label system-image="car" tag="car">Car</Label>
///         <Label system-image="bus" tag="bus">Bus</Label>
///         <Label system-image="tram" tag="tram">Tram</Label>
///     </Group>
/// </Picker>
/// ```
///
/// ## Attributes
/// - ``selection``
///
/// ## Attributes
/// - ``selection``
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
    @FormState("selection") private var selection: String?
    
    var body: some View {
        SwiftUI.Picker(selection: $selection) {
            context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
        } label: {
            context.buildChildren(of: element, forTemplate: "label", includeDefaultSlot: false)
        }
    }
}
