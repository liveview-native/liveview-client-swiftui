//
//  SecureField.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI

/// A form element for entering private text.
///
/// This element is similar to ``TextField`` but for secure text, such as passwords.
///
/// ```html
/// <SecureField prompt="Required" text="password">
///     Password
/// </SecureField>
/// ```
///
/// ## Attributes
/// * ``TextFieldProtocol/text``
/// * ``TextFieldProtocol/prompt``
///
/// ## Events
/// * ``focusEvent``
/// * ``blurEvent``
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SecureField<R: RootRegistry>: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    @LiveContext<R> var context
    @FormState("text") var text: String?
    @FocusState private var isFocused: Bool
    
    /// Sends an event when the field gains focus.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event("phx-focus", type: "focus") var focusEvent
    /// Sends an event when the field loses focus.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event("phx-blur", type: "blur") var blurEvent
    
    var body: some View {
        SwiftUI.SecureField(
            text: textBinding,
            prompt: prompt
        ) {
            label
        }
            .focused($isFocused)
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: _ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
    }
    
    var label: some View {
        context.buildChildren(of: element)
    }
}

