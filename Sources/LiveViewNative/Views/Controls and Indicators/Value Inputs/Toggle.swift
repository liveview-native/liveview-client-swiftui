//
//  Toggle.swift
//
//
//  Created by Carson Katri on 1/17/23.
//

import SwiftUI

/// A form element that controls a boolean value.
///
/// Add elements within the toggle to provide a label.
///
/// ```html
/// <Toggle isOn={@lights_on} phx-change="toggled-lights">
///     Lights On
/// </Toggle>
/// ```
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
@_documentation(visibility: public)
@LiveElement
struct Toggle<Root: RootRegistry>: View {
    @FormState("isOn", default: false) var value: Bool
    
    public var body: some View {
        SwiftUI.Toggle(isOn: $value) {
            $liveElement.children()
        }
        .focused(_value.$isFocused)
    }
}
