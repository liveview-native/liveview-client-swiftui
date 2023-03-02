//
//  TextEditor.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/8/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct TextEditor<R: RootRegistry>: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    let context: LiveContext<R>
    @FormState var value: String?
    @FocusState private var isFocused: Bool
    @LiveBinding(attribute: "find-presented") private var isFindPresented = false
    
    let focusEvent = Event("phx-focus", type: "focus")
    let blurEvent = Event("phx-blur", type: "blur")
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        SwiftUI.TextEditor(text: textBinding)
            .focused($isFocused)
            .applyAutocorrectionDisabled(disableAutocorrection)
            .applySubmitLabel(submitLabel)
#if os(iOS)
            .textInputAutocapitalization(autocapitalization)
            .applyKeyboardType(keyboard)
            .findNavigator(isPresented: $isFindPresented)
            .findDisabled(element.attributeBoolean(for: "find-disabled"))
            .replaceDisabled(element.attributeBoolean(for: "replace-disabled"))
#endif
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
    }
}

#endif
