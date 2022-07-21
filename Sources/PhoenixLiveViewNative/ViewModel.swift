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
    @Published private var forms = [String: FormModel<R>]()
    
    /// Get or create a ``FormModel`` for the `<form>` element with the given ID.
    public func getForm(elementID id: String) -> FormModel<R> {
        if let form = forms[id] {
            return form
        } else {
            let model = FormModel<R>(elementID: id)
            forms[id] = model
            return model
        }
    }
    
    /// Removes form models that don't have corresponding `<form>` tags in the DOM.
    func pruneMissingForms(elements: Elements) {
        var formIDs = Set<String>()
        var toVisit = Array(elements)
        while let el = toVisit.popLast() {
            if el.tagName().lowercased() == "form" {
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
/// To obtain a form model, use ``LiveViewModel/getForm(elementID:)``.
public class FormModel<R: CustomRegistry>: ObservableObject, CustomDebugStringConvertible {
    /// The value of the `id` attribute of the `<form>` element this model is for.
    public let elementID: String
    var coordinator: LiveViewCoordinator<R>!
    var changeEvent: String?
    /// The form data for this form.
    @Published public var data = [String: String]()
    var focusedFieldName: String?
    
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
            "\(k.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)=\(v.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        }.joined(separator: "&")

        try await coordinator.pushEvent(type: "form", event: changeEvent, value: urlQueryEncodedData)
    }
    
    public var debugDescription: String {
        return "FormModel(\(elementID))"
    }
}

private struct FormDataUpdater<R: CustomRegistry>: NodeVisitor {
    let model: FormModel<R>
    
    func head(_ node: Node, _ depth: Int) throws {
        if ["hidden", "textfield"].contains(node.nodeName().lowercased()),
           node.hasAttr("name"),
           node.hasAttr("value") {
            model.data[try! node.attr("name")] = try! node.attr("value")
        }
    }
    
    func tail(_ node: Node, _ depth: Int) throws {
        // unused
    }
}
