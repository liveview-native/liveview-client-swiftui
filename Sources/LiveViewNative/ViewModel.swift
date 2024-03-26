//
//  ViewModel.swift
// LiveViewNative
//
//  Created by Shadowfacts on 1/12/22.
//

import Foundation
import Combine
import SwiftUI
import LiveViewNativeCore

/// The working-copy data model for a ``LiveView``.
///
/// In a view in the LiveView tree, a model can be obtained using `@EnvironmentObject`.
public class LiveViewModel: ObservableObject {
    private var forms = [String: FormModel]()
    
    init() {}
    
    /// Get or create a ``FormModel`` for the given `<live-form>`.
    ///
    /// - Important: The element parameter must be the form element. To get the form model for an element within a form, use the ``LiveContext`` or the `\.formModel` environment value.
    public func getForm(elementID id: String) -> FormModel {
        if let form = forms[id] {
            return form
        } else {
            let model = FormModel(elementID: id)
            forms[id] = model
            return model
        }
    }
}

/// A form model stores the working copy of the data for a specific `<form>` element.
///
/// To obtain a form model, use ``LiveViewModel/getForm(elementID:)`` or the `\.formModel` environment key.
public class FormModel: ObservableObject, CustomDebugStringConvertible {
    let elementID: String
    @_spi(LiveForm) public var pushEventImpl: ((String, String, Any, Int?) async throws -> Void)!
    
    var changeEvent: String?
    var submitEvent: String?
    /// An action called when no `phx-submit` event is present.
    ///
    /// This typically performs a HTTP request and reconnects the LiveView.
    var submitAction: (() -> ())?
    
    /// The form data for this form.
    @Published internal private(set) var data = [String: any FormValue]()
    var formFieldWillChange = PassthroughSubject<String, Never>()
    
    init(elementID: String) {
        self.elementID = elementID
    }
    
    @_spi(LiveForm) public func updateFromElement(_ element: ElementNode, submitAction: @escaping () -> ()) {
        self.changeEvent = element.attributeValue(for: "phx-change")
        self.submitEvent = element.attributeValue(for: "phx-submit")
        self.submitAction = submitAction
    }
    
    /// Sends a phx-change event (if configured) to the server with the current form data.
    ///
    /// This method has no effect if the `<form>` does not have a `phx-change` event configured.
    ///
    /// See ``LiveViewCoordinator/pushEvent(type:event:value:target:)`` for more information.
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
    /// See ``LiveViewCoordinator/pushEvent(type:event:value:target:)`` for more information.
    @MainActor
    public func sendSubmitEvent() async throws {
        if let submitEvent = submitEvent {
            try await pushFormEvent(submitEvent)
        } else if let submitAction {
            submitAction()
        }
    }
    
    /// Create a URL encoded body from the data in the form.
    public func buildFormQuery() throws -> String {
        let encoder = JSONEncoder()
        let data = try data.mapValues { value in
            if let value = value as? String {
                return value
            } else {
                return try String(data: encoder.encode(value), encoding: .utf8)!
            }
        }
        
        var components = URLComponents()
        components.queryItems = data.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.query!
    }
    
    @MainActor
    private func pushFormEvent(_ event: String) async throws {
        // the `form` event type expects a URL encoded payload (e.g., `a=b&c=d`)
        try await pushEventImpl("form", event, try buildFormQuery(), nil)
    }
    
    public var debugDescription: String {
        return "FormModel(element: #\(elementID), id: \(ObjectIdentifier(self))"
    }
    
    /// Access the stored value, if there is one, for the form field of the given name.
    ///
    /// Setting a field to `nil` removes it.
    ///
    /// Setting a field automatically sends a change event if one was configured on the `<live-form>` element.
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
    
    /// Sets the value in ``data`` if there is no value currently present.
    func setInitialValue(_ value: any FormValue, forName name: String) {
        guard !data.keys.contains(name)
        else { return }
        data[name] = value
    }
    
    /// Clears all data in this form.
    public func clear() {
        for field in data.keys {
            formFieldWillChange.send(field)
        }
        data = [:]
    }
    
}
