//
//  PhxTextField.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxTextField<R: CustomRegistry>: View {
    private let label: String
    private let name: String
    private let placeholder: String?
    private let borderStyle: UITextField.BorderStyle
    private let clearButtonMode: UITextField.ViewMode
    private let formModel: FormModel
    @FormState private var value: String?
    @State private var becomeFirstResponder = false
    
    init(element: Element, context: LiveContext<R>) {
        precondition(context.formModel != nil, "<textfield> cannot be used outside of a <form>")
        // throwing: .attr only throws if the given attribute name is empty
        self.label = try! element.attr("label")
        self.name = try! element.attr("name")
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
        precondition(!name.isEmpty, "<textfield> must have name")
        self.formModel = context.formModel!
    }
    
    var body: some View {
        return PhxWrappedTextField(formModel: formModel, name: name, placeholder: placeholder, borderStyle: borderStyle, clearButtonMode: clearButtonMode, value: $value, becomeFirstResponder: $becomeFirstResponder)
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
    private let placeholder: String?
    private let borderStyle: UITextField.BorderStyle
    private let clearButtonMode: UITextField.ViewMode
    @Binding private var value: String?
    @Binding private var becomeFirstResponder: Bool
    
    init(formModel: FormModel, name: String, placeholder: String?, borderStyle: UITextField.BorderStyle, clearButtonMode: UITextField.ViewMode, value: Binding<String?>, becomeFirstResponder: Binding<Bool>) {
        self.formModel = formModel
        self.name = name
        self.placeholder = placeholder
        self.borderStyle = borderStyle
        self.clearButtonMode = clearButtonMode
        self._value = value
        self._becomeFirstResponder = becomeFirstResponder
    }
    
    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.borderStyle = borderStyle
        field.backgroundColor = .clear
        field.addTarget(context.coordinator, action: #selector(Coordinator.editingChanged), for: .editingChanged)
        field.delegate = context.coordinator
        // prevent text field from expanding off the screen
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return field
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = value
        uiView.placeholder = placeholder
        uiView.clearButtonMode = clearButtonMode
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
        @Binding var value: String?
        let formModel: FormModel!
        let name: String
        
        init(formModel: FormModel, name: String, value: Binding<String?>) {
            self._value = value
            self.formModel = formModel
            self.name = name
        }
        
        @objc func editingChanged(_ textField: UITextField) {
            value = textField.text
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
    }
}
