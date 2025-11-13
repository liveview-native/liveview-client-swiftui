//
//  SecureField.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI
import LightpandaClient

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
@_documentation(visibility: public)
struct SecureField<Library: ElementLibrary>: TextFieldProtocol {
    let node: Node
    
    @FormState("text", default: "") var text: String?
    
    /// Sends an event when the field gains focus.
    @_documentation(visibility: public)
    @Event("phx-focus", type: "focus") var focusEvent
    /// Sends an event when the field loses focus.
    @_documentation(visibility: public)
    @Event("phx-blur", type: "blur") var blurEvent
    
    var axis: Axis = .horizontal
    var prompt: String?
    
    var body: some View {
        SwiftUI.SecureField(
            text: textBinding,
            prompt: prompt.flatMap(SwiftUI.Text.init)
        ) {
            node.children(library: Library.self)
        }
            .focused(_text.$isFocused)
            .onChange(of: _text.isFocused, perform: handleFocus)
    }
    
    
    func handleFocus(_ isFocused: Bool) {
        if isFocused {
            focusEvent(value:
                $liveElement.element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        } else {
            blurEvent(value:
                $liveElement.element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        }
    }
}

