//
//  TextFieldProtocol.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI

protocol TextFieldProtocol: View {
    associatedtype R: CustomRegistry
    var element: ElementNode { get }
    var context: LiveContext<R> { get }
    var value: String? { get nonmutating set }
    
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
    func handleFocus(_ isFocused: Bool) {
        if isFocused {
            guard let event = element.attributeValue(for: "phx-focus") else { return }
            Task {
                try await context.coordinator.pushEvent(type: "focus", event: event, value: element.buildPhxValuePayload())
            }
        } else {
            guard let event = element.attributeValue(for: "phx-blur") else { return }
            Task {
                try await context.coordinator.pushEvent(type: "focus", event: event, value: element.buildPhxValuePayload())
            }
        }
    }
    
    var placeholder: String? {
        element.attributeValue(for: "placeholder")
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
    
#if !os(macOS)
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
    case roundedBorder = "rounded-border"
    case squareBorder = "square-border"
}

extension View {
    @ViewBuilder
    func applyTextFieldStyle(_ style: TextFieldStyle) -> some View {
        switch style {
        case .automatic:
            self.textFieldStyle(.automatic)
        case .plain:
            self.textFieldStyle(.plain)
        case .roundedBorder:
            self.textFieldStyle(.roundedBorder)
        case .squareBorder:
            #if os(macOS)
            self.textFieldStyle(.squareBorder)
            #else
            self
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
    
#if !os(macOS)
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
