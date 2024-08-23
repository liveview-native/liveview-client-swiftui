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
///         <Label systemImage="car" tag="car">Car</Label>
///         <Label systemImage="bus" tag="bus">Bus</Label>
///         <Label systemImage="tram" tag="tram">Tram</Label>
///     </Group>
/// </Picker>
/// ```
///
/// ## Attributes
/// - ``selection``
///
/// ## Children
/// - `content`
/// - `label`
@_documentation(visibility: public)
@LiveElement
struct Picker<Root: RootRegistry>: View {
    @FormState("selection") private var selection: String?
    
    var body: some View {
        SwiftUI.Picker(selection: $selection) {
            $liveElement.children(in: "content", default: true)
        } label: {
            $liveElement.children(in: "label")
        }
    }
}
