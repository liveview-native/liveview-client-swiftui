//
//  TextField.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct TextField<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    @FormState private var value: String?
    
    init(element: ElementNode, context: LiveContext<R>) {
    }
    
    public var body: some View {
        return PhxWrappedTextField(config: TextFieldConfiguration(element: element), value: $value)
            .frame(height: 44)
    }
}

fileprivate struct PhxWrappedTextField: UIViewRepresentable {
    typealias UIViewType = UITextField
    private let config: TextFieldConfiguration
    @Binding private var value: String?
    @Environment(\.textFieldPrimaryAction) private var primaryAction: (() -> Void)?
    
    init(config: TextFieldConfiguration, value: Binding<String?>) {
        self.config = config
        self._value = value
    }
    
    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.backgroundColor = .clear
        field.addTarget(context.coordinator, action: #selector(Coordinator.editingChanged), for: .editingChanged)
        field.addTarget(context.coordinator, action: #selector(Coordinator.onPrimaryAction), for: .primaryActionTriggered)
        field.delegate = context.coordinator
        // prevent text field from expanding off the screen
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return field
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = value
        config.apply(to: uiView)
        context.coordinator.value = _value
        context.coordinator.primaryAction = primaryAction
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(value: _value)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var value: Binding<String?>
        var primaryAction: (() -> Void)? = nil
        
        init(value: Binding<String?>) {
            self.value = value
        }
        
        @objc func editingChanged(_ textField: UITextField) {
            value.wrappedValue = textField.text
        }
        
        @objc func onPrimaryAction() {
            primaryAction?()
        }
    }
}

private struct TextFieldConfiguration {
    let placeholder: String?
    let borderStyle: UITextField.BorderStyle
    let clearButtonMode: UITextField.ViewMode
    let autocorrectionType: UITextAutocorrectionType
    let autocapitalizationType: UITextAutocapitalizationType
    let keyboardType: UIKeyboardType
    let isSecureTextEntry: Bool
    let returnKeyType: UIReturnKeyType
    
    init(element: ElementNode) {
        self.placeholder = element.attributeValue(for: "placeholder")
        switch element.attributeValue(for: "border-style") {
        case nil, "rounded":
            borderStyle = .roundedRect
        case "none":
            borderStyle = .none
        case let value:
            fatalError("Invalid value '\(value!)' for border-style attribute on <textfield>")
        }
        switch element.attributeValue(for: "clear-button") {
        case nil, "never":
            clearButtonMode = .never
        case "always":
            clearButtonMode = .always
        case "while-editing":
            clearButtonMode = .whileEditing
        case let value:
            fatalError("Invalid value '\(value!)' for clear-button attribute on <textfield>")
        }
        switch element.attributeValue(for: "autocorrection") {
        case nil, "default":
            autocorrectionType = .default
        case "no":
            autocorrectionType = .no
        case "yes":
            autocorrectionType = .yes
        case let value:
            fatalError("Invalid value '\(value!)' for autocorrection attribute on <textfield>")
        }
        switch element.attributeValue(for: "autocapitalization") {
        case nil, "sentences":
            autocapitalizationType = .sentences
        case "none":
            autocapitalizationType = .none
        case "words":
            autocapitalizationType = .words
        case "all-characters":
            autocapitalizationType = .allCharacters
        case let value:
            fatalError("Invalid value '\(value!)' for autocapitalization attribute on <textfield>")
        }
        switch element.attributeValue(for: "keyboard") {
        case nil, "default":
            keyboardType = .default
        case "ascii-capable":
            keyboardType = .asciiCapable
        case "numbers-and-punctuation":
            keyboardType = .numbersAndPunctuation
        case "url":
            keyboardType = .URL
        case "number-pad":
            keyboardType = .numberPad
        case "phone-pad":
            keyboardType = .phonePad
        case "name-phone-pad":
            keyboardType = .namePhonePad
        case "email":
            keyboardType = .emailAddress
        case "decimal":
            keyboardType = .decimalPad
        case "twitter":
            keyboardType = .twitter
        case "ascii-capable-number-pad":
            keyboardType = .asciiCapableNumberPad
        case let value:
            fatalError("Invalid value '\(value!)' for keyboard attribute on <textfield>")
        }
        switch element.attributeValue(for: "is-secure-text-entry") {
        case nil, "default":
            isSecureTextEntry = false
        case "no":
            isSecureTextEntry = false
        case "yes":
            isSecureTextEntry = true
        case let value:
            fatalError("Invalid value '\(value!)' for is-secure-text-entry attribute on <textfield>")
        }
        switch element.attributeValue(for: "return-key-type") {
        case nil, "default":
            returnKeyType = .default
        case "go":
            returnKeyType = .go
        case "google":
            returnKeyType = .google
        case "join":
            returnKeyType = .join
        case "next":
            returnKeyType = .next
        case "route":
            returnKeyType = .route
        case "search":
            returnKeyType = .search
        case "send":
            returnKeyType = .send
        case "yahoo":
            returnKeyType = .yahoo
        case "done":
            returnKeyType = .done
        case "emergency-call":
            returnKeyType = .emergencyCall
        case "continue":
            returnKeyType = .continue
        case let value:
            fatalError("Invalid value '\(value!)' for return-key-type attribute on <textfield>")
        }
    }
    
    func apply(to view: UITextField) {
        view.borderStyle = borderStyle
        view.placeholder = placeholder
        view.clearButtonMode = clearButtonMode
        view.autocorrectionType = autocorrectionType
        view.autocapitalizationType = autocapitalizationType
        view.keyboardType = keyboardType
        view.isSecureTextEntry = isSecureTextEntry
        view.returnKeyType = returnKeyType
    }
}
