//
//  TextField.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct TextField<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    @FormState private var value: String?
    @FocusState private var isFocused: Bool
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        field
            .focused($isFocused)
            .phxTextFieldStyle(textFieldStyle)
            .phxAutocorrectionDisabled(disableAutocorrection)
            .textInputAutocapitalization(autocapitalization)
            .phxKeyboardType(keyboard)
            .phxSubmitLabel(submitLabel)
            .onChange(of: isFocused, perform: handleFocus)
    }
    
    @ViewBuilder
    private var field: some View {
        if let format = element.attributeValue(for: "format") {
            switch format {
            case "date-time":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .dateTime),
                    format: .dateTime,
                    prompt: prompt
                )
            case "url":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .url),
                    format: .url,
                    prompt: prompt
                )
            case "iso8601":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .iso8601),
                    format: .iso8601,
                    prompt: prompt
                )
            case "number":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .number),
                    format: .number,
                    prompt: prompt
                )
            case "percent":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .percent),
                    format: .percent,
                    prompt: prompt
                )
            case let format:
                if format.starts(with: "currency-"),
                   let code = format.split(separator: "currency-").last.map(String.init)
                {
                    SwiftUI.TextField(
                        self.placeholder ?? "",
                        value: valueBinding(format: .currency(code: code)),
                        format: .currency(code: code),
                        prompt: prompt
                    )
                } else if format.starts(with: "name-"),
                          let style = format.split(separator: "name-").last
                {
                    let nameStyle: PersonNameComponents.FormatStyle.Style = {
                        switch style {
                        case "short":
                            return .short
                        case "medium":
                            return .medium
                        case "long":
                            return .long
                        case "abbreviated":
                            return .abbreviated
                        default:
                            return .medium
                        }
                    }()
                    SwiftUI.TextField(
                        self.placeholder ?? "",
                        value: valueBinding(format: .name(style: nameStyle)),
                        format: .name(style: nameStyle),
                        prompt: prompt
                    )
                } else {
                    SwiftUI.TextField(
                        self.placeholder ?? "",
                        text: textBinding,
                        prompt: prompt,
                        axis: axis
                    )
                }
            }
        } else {
            SwiftUI.TextField(
                self.placeholder ?? "",
                text: textBinding,
                prompt: prompt,
                axis: axis
            )
        }
    }
    
    func valueBinding<S: ParseableFormatStyle>(format: S) -> Binding<S.FormatInput?> where S.FormatOutput == String {
        .init {
            try? value.flatMap(format.parseStrategy.parse)
        } set: {
            value = $0.flatMap(format.format)
        }
    }
    
    private var textBinding: Binding<String> {
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
    
    private var axis: Axis {
        switch element.attributeValue(for: "axis") {
        case "horizontal":
            return .horizontal
        case "vertical":
            return .vertical
        default:
            return .horizontal
        }
    }
    
    private var prompt: SwiftUI.Text? {
        element.attributeValue(for: "prompt").map(SwiftUI.Text.init)
    }
    
    /// Use `@FocusState` to send `phx-focus` and `phx-blur` events.
    private func handleFocus(_ isFocused: Bool) {
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
    
    private var placeholder: String? {
        element.attributeValue(for: "placeholder")
    }
    
    private var textFieldStyle: PhxTextFieldStyle {
        if let s = element.attributeValue(for: "text-field-style"),
           let style = PhxTextFieldStyle(rawValue: s) {
            return style
        } else {
            return .automatic
        }
    }
    
    private var disableAutocorrection: Bool? {
        switch element.attributeValue(for: "autocorrection") {
        case "no":
            return true
        case "yes":
            return false
        default:
            return nil
        }
    }
    
    private var autocapitalization: TextInputAutocapitalization? {
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
    
    private var keyboard: UIKeyboardType? {
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
    
    private var submitLabel: SubmitLabel? {
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

fileprivate enum PhxTextFieldStyle: String {
    case automatic
    case plain
    case roundedBorder = "rounded-border"
    case squareBorder = "square-border"
}

fileprivate extension View {
    @ViewBuilder
    func phxTextFieldStyle(_ style: PhxTextFieldStyle) -> some View {
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
    func phxAutocorrectionDisabled(_ disableAutocorrection: Bool?) -> some View {
        if let disableAutocorrection {
            self.autocorrectionDisabled(disableAutocorrection)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func phxKeyboardType(_ keyboardType: UIKeyboardType?) -> some View {
        if let keyboardType {
            self.keyboardType(keyboardType)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func phxSubmitLabel(_ submitLabel: SubmitLabel?) -> some View {
        if let submitLabel {
            self.submitLabel(submitLabel)
        } else {
            self
        }
    }
}
