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
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(watchOS 9.0, *)
struct TextFieldLink<R: RootRegistry>: View {
    @ObservedElement var element: ElementNode
    @LiveContext<R> private var context
    @FormState("value") var value: String?
    
    /// Describes the reason for requesting text input.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("prompt", transform: { $0?.value.flatMap(SwiftUI.Text.init) })
    private var prompt: SwiftUI.Text?
    
    var body: some View {
#if os(watchOS)
        SwiftUI.TextFieldLink(
            prompt: prompt
        ) {
            context.buildChildren(of: element)
        } onSubmit: { newValue in
            value = newValue
        }
#endif
    }
}
