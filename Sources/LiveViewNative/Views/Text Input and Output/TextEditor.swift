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
/// <TextEditor text="my_text" phx-focus="editor_focused" />
/// ```
///
/// ## Events
/// - ``focusEvent``
/// - ``blurEvent``
@_documentation(visibility: public)
@available(iOS 16.0, macOS 13.0, *)
struct TextEditor: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    @FormState("text") var text: String?
    @FocusState private var isFocused: Bool
    
    /// An event that fires when the text editor is focused.
    @_documentation(visibility: public)
    @Event("phx-focus", type: "focus") var focusEvent
    /// An event that fires when the text editor is unfocused.
    @_documentation(visibility: public)
    @Event("phx-blur", type: "blur") var blurEvent
    
    var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.TextEditor(text: textBinding)
            .focused($isFocused)
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: _ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
#endif
    }
}
