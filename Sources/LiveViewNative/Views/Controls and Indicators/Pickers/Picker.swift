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
        SwiftUI.Picker.init(selection: $selection) {
            ForEach($liveElement.childNodes(in: "content", default: true), id: \.id) { node in
                if let element = node.asElement() {
                    // For simple Text elements, we can skip the slow element conversion, and convert directly to Text.
                    // This will be a common path for apps using `Picker` with large numbers of elements.
                    if element.tag == "Text",
                       element.attributes.count == 1,
                       let attribute = element.attributes.first,
                       attribute.name.namespace == nil,
                       attribute.name.name == "tag"
                    {
                        SwiftUI.Text(verbatim: element.innerText())
                            .tag(attribute.value)
                    } else {
                        $liveElement.context.buildElement(element)
                    }
                }
            }
        } label: {
            $liveElement.children(in: "label")
        }
    }
}
