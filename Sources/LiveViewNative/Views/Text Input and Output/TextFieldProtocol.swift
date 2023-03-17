//
//  TextFieldProtocol.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI

protocol TextFieldProtocol: View {
    associatedtype R: RootRegistry
    var element: ElementNode { get }
    var context: LiveContext<R> { get }
    var value: String? { get nonmutating set }
    
    var focusEvent: Event { get }
    var blurEvent: Event { get }
    
    init(element: ElementNode, context: LiveContext<R>)
}

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
            if $0.isEmpty {
                value = nil
            } else {
                value = $0
            }
        }
    }
    
    var label: some View {
        context.buildChildren(of: element)
    }
    
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
    
    var prompt: SwiftUI.Text? {
        element.attributeValue(for: "prompt").map(SwiftUI.Text.init)
    }
    
    /// Use `@FocusState` to send `phx-focus` and `phx-blur` events.
    @MainActor
    func handleFocus(_ isFocused: Bool) {
        if isFocused {
            focusEvent.wrappedValue(value:
                element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        } else {
            blurEvent.wrappedValue(value:
                element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        }
    }
    
    var textFieldStyle: TextFieldStyle {
        if let s = element.attributeValue(for: "text-field-style"),
           let style = TextFieldStyle(rawValue: s) {
            return style
        } else {
            return .automatic
        }
    }
    
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
    
#if !os(macOS)
    var autocapitalization: TextInputAutocapitalization? {
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
    }
#endif
    
#if os(iOS) || os(tvOS)
    var keyboard: UIKeyboardType? {
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
    }
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

enum TextFieldStyle: String {
    case automatic
    case plain
#if !os(watchOS)
    case roundedBorder = "rounded-border"
#endif
#if os(macOS)
    case squareBorder = "square-border"
#endif
}

extension View {
    @ViewBuilder
    func applyTextFieldStyle(_ style: TextFieldStyle) -> some View {
        switch style {
        case .automatic:
            self.textFieldStyle(.automatic)
        case .plain:
            self.textFieldStyle(.plain)
#if !os(watchOS)
        case .roundedBorder:
            self.textFieldStyle(.roundedBorder)
#endif
#if os(macOS)
        case .squareBorder:
            self.textFieldStyle(.squareBorder)
#endif
        }
    }
    
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
