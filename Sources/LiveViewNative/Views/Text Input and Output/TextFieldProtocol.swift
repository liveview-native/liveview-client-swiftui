//
//  TextFieldProtocol.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
protocol TextFieldProtocol: View {
    var element: ElementNode { get }
    var value: String? { get nonmutating set }
    
    var focusEvent: Event.EventHandler { get }
    var blurEvent: Event.EventHandler { get }
}

/// Common behaviors and supporting types for text fields.
///
/// ## Topics
/// ### Supporting Types
/// - ``TextFieldStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension TextFieldProtocol {
    func valueBinding<S: ParseableFormatStyle>(format: S) -> Binding<S.FormatInput?> where S.FormatOutput == String {
        .init {
            try? value.flatMap(format.parseStrategy.parse)
        } set: {
            value = $0.flatMap(format.format)
        }
    }
    
    var textBinding: Binding<String> {
        Binding {
            value ?? ""
        } set: {
            value = $0
        }
    }
    
    /// The axis to scroll when the content doesn't fit.
    ///
    /// Possible values:
    /// * `horizontal`
    /// * `vertical`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
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
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    var prompt: SwiftUI.Text? {
        element.attributeValue(for: "prompt").map(SwiftUI.Text.init)
    }
    
    /// Use `@FocusState` to send `phx-focus` and `phx-blur` events.
    @MainActor
    func handleFocus(_ isFocused: Bool) {
        if isFocused {
            focusEvent(value:
                element.buildPhxValuePayload()
                    .merging(["value": .string(textBinding.wrappedValue)], uniquingKeysWith: { a, _ in a })
            )
        } else {
            blurEvent(value:
                element.buildPhxValuePayload()
                    .merging(["value": .string(textBinding.wrappedValue)], uniquingKeysWith: { a, _ in a })
            )
        }
    }
}
