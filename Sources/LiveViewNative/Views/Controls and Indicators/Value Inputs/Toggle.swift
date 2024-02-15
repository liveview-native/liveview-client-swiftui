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
struct Toggle<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @FormState("isOn", default: false) var value: Bool
    
    public var body: some View {
        SwiftUI.Toggle(isOn: $value) {
            context.buildChildren(of: element)
        }
    }
}
