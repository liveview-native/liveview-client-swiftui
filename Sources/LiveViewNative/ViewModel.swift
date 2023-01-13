//
//  ViewModel.swift
// LiveViewNative
//
//  Created by Shadowfacts on 1/12/22.
//

import Foundation
import Combine
import LiveViewNativeCore

/// The working-copy data model for a ``LiveView``.
///
/// In a view in the LiveView tree, a model can be obtained using `@EnvironmentObject`.
public class LiveViewModel<R: CustomRegistry>: ObservableObject {
    private var forms = [String: FormModel]()
    
    /// Get or create a ``FormModel`` for the `<form>` element with the given ID.
    public func getForm(elementID id: String) -> FormModel {
        if let form = forms[id] {
            return form
        } else {
            let model = FormModel(elementID: id)
            forms[id] = model
            return model
        }
    }
    
    /// Called whenever the document changes to update form models with their current data from the DOM and remove any models for no-longer-present forms.
    func updateForms(nodes: NodeDepthFirstChildrenSequence) {
        var formIDs = Set<String>()
        for node in nodes {
            guard case .element(let elementData) = node.data,
                  elementData.namespace == nil && elementData.tag == "phx-form" else {
                continue
            }
            let id = node["id"]!.value!
            formIDs.insert(id)
            forms[id]?.updateFromElement(ElementNode(node: node, data: elementData))
        }
        for id in forms.keys where !formIDs.contains(id) {
            forms.removeValue(forKey: id)
        }
    }
}

/// A form model stores the working copy of the data for a specific `<form>` element.
///
/// To obtain a form model, use ``LiveViewModel/getForm(elementID:)`` or the `\.formModel` environment key.
public class FormModel: ObservableObject, CustomDebugStringConvertible {
    /// The value of the `id` attribute of the `<form>` element this model is for.
    public let elementID: String
    var pushEventImpl: ((String, String, Any) async throws -> Void)!
    var changeEvent: String?
    var submitEvent: String?
    /// The form data for this form.
    @Published internal private(set) var data = [String: any FormValue]()
    var focusedFieldName: String?
    var formFieldWillChange = PassthroughSubject<String, Never>()
    
    init(elementID: String) {
        self.elementID = elementID
    }
    
    func updateFromElement(_ element: ElementNode) {
        changeEvent = element.attributeValue(for: "phx-change")
        submitEvent = element.attributeValue(for: "phx-submit")
        
        for node in element.depthFirstChildren() {
            guard case .element(let elementData) = node.data else {
                continue
            }
            // TODO: should this cover all elements?
            if elementData.namespace == nil,
               ["hidden", "textfield"].contains(elementData.tag),
               let name = node["name"]?.value,
               let value = node["value"]?.value {
                // if we have an existing value, try to convert it to the same type
                if let existing = self[name],
                   let converted = existing.createNew(formValue: value) {
                    self[name] = converted
                } else {
                    self[name] = value
                }
            }
        }
    }
    
    /// Sends a phx-change event (if configured) to the server with the current form data.
    ///
    /// This method has no effect if the `<form>` does not have a `phx-change` event configured.
    ///
    /// See ``LiveViewCoordinator/pushEvent(type:event:value:)`` for more information.
    @MainActor
    public func sendChangeEvent() async throws {
        if let changeEvent = changeEvent {
            try await pushFormEvent(changeEvent)
        }
    }
    
    /// Sends a phx-submit event (if configured) to the server with the current form data.
    ///
    /// This method has no effect if the `<form>` does not have a `phx-submit` event configured.
    ///
    /// See ``LiveViewCoordinator/pushEvent(type:event:value:)`` for more information.
    @MainActor
    public func sendSubmitEvent() async throws {
        if let submitEvent = submitEvent {
            try await pushFormEvent(submitEvent)
        }
    }
    
    @MainActor
    private func pushFormEvent(_ event: String) async throws {
        let urlQueryEncodedData = data.map { k, v in
            // todo: in what cases does addingPercentEncoding return nil? do we care?
            "\(k.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)=\(v.formValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        }.joined(separator: "&")

        try await pushEventImpl("form", event, urlQueryEncodedData)
    }
    
    public var debugDescription: String {
        return "FormModel(element: #\(elementID), id: \(ObjectIdentifier(self))"
    }
    
    /// Access the stored value, if there is one, for the form field of the given name.
    ///
    /// Setting a field to `nil` removes it.
    ///
    /// Setting a field automatically sends a change event if one was configured on the `<phx-form>` element.
    public subscript(name: String) -> (any FormValue)? {
        get {
            return data[name]
        }
        set(newValue) {
            if let existing = data[name],
               let newValue = newValue {
                if !existing.isEqual(to: newValue) {
                    formFieldWillChange.send(name)
                }
            } else if data[name] != nil || newValue != nil {
                // something -> nil or nil -> something
                formFieldWillChange.send(name)
            } else {
                // nothing to do
                return
            }
            data[name] = newValue
            Task {
                try? await sendChangeEvent()
            }
        }
    }
    
    /// Clears all data in this form.
    public func clear() {
        for field in data.keys {
            formFieldWillChange.send(field)
        }
        data = [:]
    }
    
}

/// A form value is any type that can be stored in a ``FormModel``. This protocol defines the requirements for converting to/from the serialized form data representation.
public protocol FormValue: Equatable {
    /// Converts the value from this type to the string representation.
    var formValue: String { get }
    
    /// Converts the value from the string representation to this type.
    init?(formValue: String)
}

extension FormValue {
    func isEqual<T>(to other: T) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
    
    func createNew(formValue: String) -> Self? {
        return Self(formValue: formValue)
    }
}

extension Optional: FormValue where Wrapped: FormValue {
    public var formValue: String {
        if let value = self {
            return value.formValue
        } else {
            return ""
        }
    }
    
    public init?(formValue: String) {
        self = Wrapped(formValue: formValue)
    }
}

extension String: FormValue {
    public var formValue: String { self }
    
    public init(formValue: String) {
        self = formValue
    }
}
