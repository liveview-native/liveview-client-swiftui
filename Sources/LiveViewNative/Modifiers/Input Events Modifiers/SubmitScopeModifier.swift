//
//  SubmitScopeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/10/2023.
//

import SwiftUI

/// Scopes an ``OnSubmitModifier`` modifier to a specific element.
/// 
/// This modifier can be used to prevent an ``OnSubmitModifier`` modifier on a parent element from triggering when a child element is submitted.
/// 
/// ```html
/// <Form modifiers={on_submit("submit")}>
///   <TextField text="username">Username</TextField>
///   <SecureField text="password">Password</SecureField>
///   
///   <TextField text="tags" modifiers={submit_scope(true)}>Tags</TextField>
/// </Form>
/// ```
/// 
/// In the example above, pressing the submit button when focused on the "Username" or "Password" field will send the `submit` event.
/// However, the "Tags" field will not send that event when submitted.
/// 
/// ## Arguments
/// * ``isBlocking``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SubmitScopeModifier: ViewModifier, Decodable {
    /// Sets whether the scope prevents parent ``OnSubmitModifier`` modifiers from triggering.
    /// Defaults to `true`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isBlocking: Bool

    func body(content: Content) -> some View {
        content.submitScope(isBlocking)
    }
}

