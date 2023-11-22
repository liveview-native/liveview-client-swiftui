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
@ParseableExpression
struct _OnSubmitModifier: ViewModifier {
    static let name = "onSubmit"
    
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
