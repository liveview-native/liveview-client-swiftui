//
//  PhxTextField.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxTextField<R: CustomRegistry>: View {
    private let name: String
    private let config: TextFieldConfiguration
    private let formModel: FormModel
    @FormState private var value: String?
    @State private var becomeFirstResponder = false
    
    init(element: Element, context: LiveContext<R>) {
        precondition(context.formModel != nil, "<textfield> cannot be used outside of a <form>")
        // throwing: .attr only throws if the given attribute name is empty
        self.name = try! element.attr("name")
        self.config = TextFieldConfiguration(element: element)
        precondition(!name.isEmpty, "<textfield> must have name")
        self.formModel = context.formModel!
    }
    
    public var body: some View {
        return PhxWrappedTextField(formModel: formModel, name: name, config: config, value: $value, becomeFirstResponder: $becomeFirstResponder)
            .frame(height: 44)
            .onAppear {
                // If the DOM changes, the text field can get re-created and destroyed even though
                if formModel.focusedFieldName == name {
                    becomeFirstResponder = true
                }
            }
    }
}

// We need to wrap UITextField ourselves so we can call becomeFirstResponder directly.
fileprivate struct PhxWrappedTextField: UIViewRepresentable {
    typealias UIViewType = UITextField
    private let formModel: FormModel
    private let name: String
    private let config: TextFieldConfiguration
    @Binding private var value: String?
    @Binding private var becomeFirstResponder: Bool
    @Environment(\.textFieldPrimaryAction) private var primaryAction: (() -> Void)?
    
    init(formModel: FormModel, name: String, config: TextFieldConfiguration, value: Binding<String?>, becomeFirstResponder: Binding<Bool>) {
        self.formModel = formModel
        self.name = name
        self.config = config
        self._value = value
        self._becomeFirstResponder = becomeFirstResponder
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
        if becomeFirstResponder {
            DispatchQueue.main.async {
                // becoming first responder immediately breaks some internal autocorrect thing, so we wait until the next runloop iteration
                uiView.becomeFirstResponder()
                // can't change state during view update, so wait until the next runloop iteration
                self.becomeFirstResponder = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(formModel: formModel, name: name, value: _value)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var value: Binding<String?>
        var primaryAction: (() -> Void)? = nil
        let formModel: FormModel!
        let name: String
        
        init(formModel: FormModel, name: String, value: Binding<String?>) {
            self.value = value
            self.formModel = formModel
            self.name = name
        }
        
        @objc func editingChanged(_ textField: UITextField) {
            value.wrappedValue = textField.text
            // todo: should change events be debounced?
            Task {
                try await formModel.sendChangeEvent()
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // We save the edited form field name to the form model so that if the DOM changes
            // and the text field is destroyed/recreated, we can re-focus it.
            formModel.focusedFieldName = name
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            formModel.focusedFieldName = nil
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
    
    init(element: Element) {
        self.placeholder = element.attrIfPresent("placeholder")
        switch element.attrIfPresent("border-style") {
        case nil, "rounded":
            borderStyle = .roundedRect
        case "none":
            borderStyle = .none
        default:
            fatalError("Invalid value '\(element.attrIfPresent("border-style")!)' for border-style attribute on <textfield>")
        }
        switch element.attrIfPresent("clear-button") {
        case nil, "never":
            clearButtonMode = .never
        case "always":
            clearButtonMode = .always
        case "while-editing":
            clearButtonMode = .whileEditing
        default:
            fatalError("Invalid value '\(element.attrIfPresent("clear-button")!)' for clear-button attribute on <textfield>")
        }
        switch element.attrIfPresent("autocorrection") {
        case nil, "default":
            autocorrectionType = .default
        case "no":
            autocorrectionType = .no
        case "yes":
            autocorrectionType = .yes
        default:
            fatalError("Invalid value '\(element.attrIfPresent("autocorrection")!)' for autocorrection attribute on <textfield>")
        }
        switch element.attrIfPresent("autocapitalization") {
        case nil, "sentences":
            autocapitalizationType = .sentences
        case "none":
            autocapitalizationType = .none
        case "words":
            autocapitalizationType = .words
        case "all-characters":
            autocapitalizationType = .allCharacters
        default:
            fatalError("Invalid value '\(element.attrIfPresent("autocapitalization")!)' for autocapitalization attribute on <textfield>")
        }
        switch element.attrIfPresent("keyboard") {
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
        default:
            fatalError("Invalid value '\(element.attrIfPresent("keyboard")!)' for keyboard attribute on <textfield>")
        }
        switch element.attrIfPresent("is-secure-text-entry") {
        case nil, "default":
            isSecureTextEntry = false
        case "no":
            isSecureTextEntry = false
        case "yes":
            isSecureTextEntry = true
        default:
            fatalError("Invalid value '\(element.attrIfPresent("is-secure-text-entry")!)' for is-secure-text-entry attribute on <textfield>")
        }
        switch element.attrIfPresent("return-key-type") {
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
        default:
            fatalError("Invalid value '\(element.attrIfPresent("return-key-type")!)' for return-key-type attribute on <textfield>")
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
