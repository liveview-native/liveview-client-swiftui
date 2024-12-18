//
//  OnSubmitModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// Last argument has no label, which is incompatible with the stylesheet format.
/// See [`SwiftUI.View/onSubmit(of:action:)`](https://developer.apple.com/documentation/swiftui/view/onSubmit(of:_:)) for more details on this ViewModifier.
///
/// ### onSubmit(of:action:)
/// - `of`: ``SwiftUI/SubmitTriggers``
/// - `action`: `event("...")` (required)
///
/// See [`SwiftUI.View/onSubmit(of:action:)`](https://developer.apple.com/documentation/swiftui/view/onSubmit(of:_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   onSubmit(of: .text, action: event("action"))
/// end
/// ```
///
/// ```elixir
/// # LiveView
/// def handle_event("action", params, socket)
/// ```
@_documentation(visibility: public)
@ASTDecodable("onSubmit")
struct _OnSubmitModifier: ViewModifier {
    let triggers: SubmitTriggers
    @Event private var action: Event.EventHandler
    
    init(of triggers: SubmitTriggers = .text, action: Event) {
        self.triggers = triggers
        self._action = action
    }
    
    func body(content: Content) -> some View {
        content.onSubmit(of: triggers, { action() })
    }
}
