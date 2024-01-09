//
//  TextFieldProtocol.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI

@_documentation(visibility: public)
protocol TextFieldProtocol: View {
    var element: ElementNode { get }
    var text: String? { get nonmutating set }
    
    var focusEvent: Event.EventHandler { get }
    var blurEvent: Event.EventHandler { get }
}

/// Common behaviors and supporting types for text fields.
///
/// ## Topics
/// ### Supporting Types
/// - ``TextFieldStyle``
@_documentation(visibility: public)
extension TextFieldProtocol {
    func valueBinding<S: ParseableFormatStyle>(format: S) -> Binding<S.FormatInput?> where S.FormatOutput == String {
        .init {
            try? text.flatMap(format.parseStrategy.parse)
        } set: {
            text = $0.flatMap(format.format)
        }
    }
    
    var textBinding: Binding<String> {
        Binding {
            text ?? ""
        } set: {
            text = $0
        }
    }
    
    /// The axis to scroll when the content doesn't fit.
    ///
    /// Possible values:
    /// * `horizontal`
    /// * `vertical`
    @_documentation(visibility: public)
    var axis: Axis {
        switch element.attributeValue(for: "axis") {
        case "horizontal":
            return .horizontal
        case "vertical":
            return .vertical
        default:
            return .horizontal
        }
    }
    
    /// Additional text with guidance on what to enter.
    @_documentation(visibility: public)
    var prompt: SwiftUI.Text? {
        element.attributeValue(for: "prompt").map(SwiftUI.Text.init)
    }
    
    /// Use `@FocusState` to send `phx-focus` and `phx-blur` events.
    @MainActor
    func handleFocus(_ isFocused: Bool) {
        if isFocused {
            focusEvent(value:
                element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        } else {
            blurEvent(value:
                element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        }
    }
}
