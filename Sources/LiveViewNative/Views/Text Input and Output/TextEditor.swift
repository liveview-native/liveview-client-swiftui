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
@LiveElement
struct TextEditor<Root: RootRegistry>: TextFieldProtocol {
    @FormState("text") var text: String?
    @LiveElementIgnored
    @FocusState private var isFocused: Bool
    
    /// An event that fires when the text editor is focused.
    @_documentation(visibility: public)
    @Event("phx-focus", type: "focus") var focusEvent
    /// An event that fires when the text editor is unfocused.
    @_documentation(visibility: public)
    @Event("phx-blur", type: "blur") var blurEvent
    
    var axis: Axis = .horizontal
    var prompt: String?
    
    var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.TextEditor(text: textBinding)
            .focused($isFocused)
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: _ProvidedBindingsKey.self, value: [.focus, .blur])
#endif
    }
    
    @MainActor
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
