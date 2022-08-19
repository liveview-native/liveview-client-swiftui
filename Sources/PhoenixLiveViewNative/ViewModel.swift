//
//  ViewModel.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 1/12/22.
//

import Foundation
import SwiftSoup
import Combine

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
    
    /// Removes form models that don't have corresponding `<phx-form>` tags in the DOM.
    func pruneMissingForms(elements: Elements) {
        var formIDs = Set<String>()
        var toVisit = Array(elements)
        while let el = toVisit.popLast() {
            if el.tagName().lowercased() == "phx-form" {
                formIDs.insert(el.id())
            }
            toVisit.append(contentsOf: el.children())
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
    /// The form data for this form.
    @Published internal private(set) var data = [String: AnyFormValue]()
    var focusedFieldName: String?
    var formFieldWillChange = PassthroughSubject<String, Never>()
    
    init(elementID: String) {
        self.elementID = elementID
    }
    
    func updateFromElement(_ element: Element) {
        try! element.traverse(FormDataUpdater(model: self))
    }
    
    /// Sends a phx-change event (if configured) to the server with the current form data.
    ///
    /// This method has no effect if the `<form>` does not have a `phx-change` event configured.
    ///
    /// See ``LiveViewCoordinator/pushEvent(type:event:value:)`` for more information.
    @MainActor
    public func sendChangeEvent() async throws {
        guard let changeEvent = changeEvent else {
            return
        }
        
        let urlQueryEncodedData = data.map { k, v in
            // todo: in what cases does addingPercentEncoding return nil? do we care?
            "\(k.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)=\(v.formValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        }.joined(separator: "&")

        try await pushEventImpl("form", changeEvent, urlQueryEncodedData)
    }
    
    public var debugDescription: String {
        return "FormModel(element: #\(elementID), id: \(ObjectIdentifier(self))"
    }
    
    /// Access the stored value, if there is one, for the form field of the given name.
    ///
    /// Setting a field to `nil` removes it.
    public subscript(name: String) -> AnyFormValue? {
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
        }
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

#if compiler(>=5.7)
public typealias AnyFormValue = any FormValue
#else
public struct AnyFormValue: FormValue, Equatable {
    public let formValue: String
    
    public init?(formValue: String) {
        self.formValue = formValue
    }
    
    init<V: FormValue>(erasing value: V) {
        self.formValue = value.formValue
    }
}
#endif

private struct FormDataUpdater: NodeVisitor {
    let model: FormModel
    
    func head(_ node: Node, _ depth: Int) throws {
        // TODO: should this cover all elements?
        if ["hidden", "textfield"].contains(node.nodeName().lowercased()),
           let name = node.attrIfPresent("name"),
           let value = node.attrIfPresent("value") {
            #if compiler(>=5.7)
            // if we have an existing value, try to convert it to the same type
            if let existing = model[name],
               let converted = existing.createNew(formValue: value) {
                model[name] = converted
            } else {
                model[name] = value
            }
            #else
            model[name] = AnyFormValue(erasing: value)
            #endif
        }
    }
    
    func tail(_ node: Node, _ depth: Int) throws {
        // unused
    }
}
