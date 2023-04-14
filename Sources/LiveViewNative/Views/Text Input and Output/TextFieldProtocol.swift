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
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        } else {
            blurEvent(value:
                element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        }
    }
    
    /// Indicates if autocorrection should be enabled.
    ///
    /// Possible values:
    /// * `yes`
    /// * `no`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    var disableAutocorrection: Bool? {
        switch element.attributeValue(for: "autocorrection") {
        case "no":
            return true
        case "yes":
            return false
        default:
            return nil
        }
    }
    
    #if os(macOS)
    typealias TextInputAutocapitalization = Never
    #endif
    
    /// The boundaries to capitalize on.
    ///
    /// Possible values:
    /// * `sentences`
    /// * `words`
    /// * `characters`
    /// * `never`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    var autocapitalization: TextInputAutocapitalization? {
        #if !os(macOS)
        switch element.attributeValue(for: "autocapitalization") {
        case "sentences":
            return .sentences
        case "words":
            return .words
        case "characters":
            return .characters
        case "never":
            return .never
        default:
            return nil
        }
        #else
        fatalError()
        #endif
    }
    
    #if !os(iOS) && !os(tvOS)
    typealias UIKeyboardType = Never
    #endif
    
    /// The type of keyboard to display.
    ///
    /// Possible values:
    /// * `ascii-capable`
    /// * `numbers-and-punctuation`
    /// * `url`
    /// * `number-pad`
    /// * `phone-pad`
    /// * `name-phone-pad`
    /// * `email-address`
    /// * `decimal-pad`
    /// * `twitter`
    /// * `web-search`
    /// * `ascii-capable-number-pad`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, tvOS 16.0, *)
    var keyboard: UIKeyboardType? {
        #if os(iOS) || os(tvOS)
        switch element.attributeValue(for: "keyboard") {
        case "ascii-capable":
            return .asciiCapable
        case "numbers-and-punctuation":
            return .numbersAndPunctuation
        case "url":
            return .URL
        case "number-pad":
            return .numberPad
        case "phone-pad":
            return .phonePad
        case "name-phone-pad":
            return .namePhonePad
        case "email-address":
            return .emailAddress
        case "decimal-pad":
            return .decimalPad
        case "twitter":
            return .twitter
        case "web-search":
            return .webSearch
        case "ascii-capable-number-pad":
            return .asciiCapableNumberPad
        default:
            return nil
        }
        #else
        fatalError()
        #endif
    }
    
    /// The label to display on the keyboard submit button.
    ///
    /// Possible values:
    /// * `done`
    /// * `go`
    /// * `send`
    /// * `join`
    /// * `route`
    /// * `search`
    /// * `return`
    /// * `next`
    /// * `continue`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    var submitLabel: SubmitLabel? {
        switch element.attributeValue(for: "submit-label") {
        case "done":
            return .done
        case "go":
            return .go
        case "send":
            return .send
        case "join":
            return .join
        case "route":
            return .route
        case "search":
            return .search
        case "return":
            return .`return`
        case "next":
            return .next
        case "continue":
            return .continue
        default:
            return nil
        }
    }
}

extension View {
    @ViewBuilder
    func applyAutocorrectionDisabled(_ disableAutocorrection: Bool?) -> some View {
        if let disableAutocorrection {
            self.autocorrectionDisabled(disableAutocorrection)
        } else {
            self
        }
    }
    
#if os(iOS) || os(tvOS)
    @ViewBuilder
    func applyKeyboardType(_ keyboardType: UIKeyboardType?) -> some View {
        if let keyboardType {
            self.keyboardType(keyboardType)
        } else {
            self
        }
    }
#endif
    
    @ViewBuilder
    func applySubmitLabel(_ submitLabel: SubmitLabel?) -> some View {
        if let submitLabel {
            self.submitLabel(submitLabel)
        } else {
            self
        }
    }
}
