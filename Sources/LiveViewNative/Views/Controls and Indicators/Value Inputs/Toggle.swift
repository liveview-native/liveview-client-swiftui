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
/// <Toggle is-on={@lights_on} phx-change="toggled-lights">
///     Lights On
/// </Toggle>
/// ```
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Toggle<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @FormState("is-on", default: false) var value: Bool
    
    public var body: some View {
        SwiftUI.Toggle(isOn: $value) {
            context.buildChildren(of: element)
        }
    }
}
