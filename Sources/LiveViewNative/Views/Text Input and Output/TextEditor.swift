//
//  TextEditor.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/8/23.
//

import SwiftUI

/// A multi-line, long-form text editor.
///
/// ```html
/// <TextEditor value-binding="my_text" phx-focus="editor_focused" />
/// ```
///
/// ## Attributes
/// - ``findDisabled``
/// - ``replaceDisabled``
/// - ``TextFieldProtocol/disableAutocorrection``
/// - ``TextFieldProtocol/autocapitalization``
/// - ``TextFieldProtocol/submitLabel``
/// - ``TextFieldProtocol/keyboard``
/// ## Events
/// - ``focusEvent``
/// - ``blurEvent``
/// ## Bindings
/// - ``isFindPresented``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct TextEditor: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    @FormState var value: String?
    @FocusState private var isFocused: Bool
    /// The `find-presented` attribute is a live binding that controls whether the system find UI is presented.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "find-presented") private var isFindPresented = false
    
    /// An event that fires when the text editor is focused.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event("phx-focus", type: "focus") var focusEvent
    /// An event that fires when the text editor is unfocused.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event("phx-blur", type: "blur") var blurEvent
    /// Whether find is disabled (defaults to false).
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("find-disabled") private var findDisabled: Bool
    /// Whether replace is disabled (defaults to false).
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("replace-disabled") private var replaceDisabled: Bool
    
    var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.TextEditor(text: textBinding)
            .focused($isFocused)
            .applyAutocorrectionDisabled(disableAutocorrection)
            .applySubmitLabel(submitLabel)
#if os(iOS)
            .textInputAutocapitalization(autocapitalization)
            .applyKeyboardType(keyboard)
            .findNavigator(isPresented: $isFindPresented)
            .findDisabled(findDisabled)
            .replaceDisabled(replaceDisabled)
#endif
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
#endif
    }
}
