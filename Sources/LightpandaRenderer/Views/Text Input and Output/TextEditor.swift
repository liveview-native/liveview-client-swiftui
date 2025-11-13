//
//  TextEditor.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/8/23.
//

import SwiftUI
import LightpandaClient

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
struct TextEditor<Library: ElementLibrary>: TextFieldProtocol {
    let node: Node
    
    @FormState("text", default: "") var text: String?
    
    /// An event that fires when the text editor is focused.
    @_documentation(visibility: public)
    @Event("phx-focus", type: "focus") var focusEvent
    /// An event that fires when the text editor is unfocused.
    @_documentation(visibility: public)
    @Event("phx-blur", type: "blur") var blurEvent
    
    var axis: Axis {
        node.attributeValue(for: "axis", strategy: AxisParseStrategy()) ?? .horizontal
    }
    var prompt: String?
    
    var body: some View {
#if os(iOS) || os(macOS)
        SwiftUI.TextEditor(text: textBinding)
            .focused(_text.$isFocused)
            .onChange(of: _text.isFocused, perform: handleFocus)
#endif
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

struct AxisParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Axis {
        switch value {
        case "horizontal":
            return .horizontal
        case "vertical":
            return .vertical
        default:
            throw ParseError()
        }
    }
}
