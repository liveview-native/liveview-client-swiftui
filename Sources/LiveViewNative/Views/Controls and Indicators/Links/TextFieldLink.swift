//
//  TextFieldLink.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI

/// A form element that requests text input on Apple Watch.
///
/// This element displays a button that, when tapped, opens a dialogue for inputting text.
///
/// ```html
/// <TextFieldLink prompt="Favorite Color" value="color">
///     What's your favorite color?
/// </TextFieldLink>
/// ```
///
/// ## Attributes
/// * ``prompt``
/// * ``value``
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
@_documentation(visibility: public)
@available(watchOS 9.0, *)
struct TextFieldLink<Root: RootRegistry>: View {
    @FormState("value") private var value: String?
    
    /// Describes the reason for requesting text input.
    @_documentation(visibility: public)
    private var prompt: String?
    
    var body: some View {
#if os(watchOS)
        SwiftUI.TextFieldLink(
            prompt: prompt.flatMap(SwiftUI.Text.init)
        ) {
            $liveElement.children()
        } onSubmit: { newValue in
            value = newValue
        }
#endif
    }
}
