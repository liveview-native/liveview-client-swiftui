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
import UniformTypeIdentifiers

/// The working-copy data model for a ``LiveView``.
///
/// In a view in the LiveView tree, a model can be obtained using `@EnvironmentObject`.
@MainActor
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
    
    func clearForms() {
        self.forms.removeAll()
    }
    
    public func fileUpload(id: String) -> FormModel.FileUpload? {
        for (_, form) in forms {
            guard let file = form.fileUploads.first(where: { $0.id == id })
            else { continue }
            return file
        }
        return nil
    }
}

/// A form model stores the working copy of the data for a specific `<form>` element.
///
/// To obtain a form model, use ``LiveViewModel/getForm(elementID:)`` or the `\.formModel` environment key.
@MainActor
public class FormModel: ObservableObject, CustomDebugStringConvertible {
    let elementID: String
    @_spi(LiveForm) public var pushEventImpl: (@MainActor (String, String, Any, Int?) async throws -> [String:Any]?)!
    
    var changeEvent: ((Any) async throws -> ())?
    var changeEventName: String?
    var submitEvent: String?
    /// An action called when no `phx-submit` event is present.
    ///
    /// This typically performs a HTTP request and reconnects the LiveView.
    var submitAction: (() -> ())?

    /// The form data for this form.
    @Published internal private(set) var data = [String: any FormValue]()
    var formFieldWillChange = PassthroughSubject<String, Never>()
    
    /// A publisher that emits a value before sending the form submission event.
    var formWillSubmit = PassthroughSubject<(), Never>()
    
    var fileUploads: [FileUpload] = []
    public struct FileUpload: Identifiable {
        public let id: String
        public let data: Data
        public let ref: Int
        let upload: () async throws -> ()
    }
    
    init(elementID: String) {
        self.elementID = elementID
    }

    @_spi(LiveForm) @preconcurrency public func updateFromElement(_ element: ElementNode, submitAction: @escaping () -> ()) {
        self.fileUploads.removeAll()
        let pushEventImpl = pushEventImpl!
        self.changeEventName = element.attributeValue(for: .init(name: "phx-change"))
        self.changeEvent = self.changeEventName.flatMap({ event in
            { value in
                Task {
                    _ = try await pushEventImpl("form", event, value, nil)
                }
            }
        })
        self.submitEvent = element.attributeValue(for: .init(name: "phx-submit"))
        self.submitAction = submitAction
    }

    /// Sends a phx-change event (if configured) to the server with the current form data.
    ///
    /// This method has no effect if the `<form>` does not have a `phx-change` event configured.
    ///
    /// See ``LiveViewCoordinator/pushEvent(type:event:value:target:)`` for more information.
    public func sendChangeEvent(_ value: any FormValue, for name: String, event: Event.EventHandler?) async throws {
        guard let event = sendChangeEventForFormElement(value, for: name, event?.callAsFunction)
                ?? sendChangeEventForForm(for: name, changeEvent) else { return }
        
        try await event()
    }

    /// Sends a phx-submit event (if configured) to the server with the current form data.
    ///
    /// This method has no effect if the `<form>` does not have a `phx-submit` event configured.
    ///
    /// See ``LiveViewCoordinator/pushEvent(type:event:value:target:)`` for more information.
    public func sendSubmitEvent() async throws {
        formWillSubmit.send(())
        for fileUpload in fileUploads {
            try await fileUpload.upload()
        }
        self.fileUploads.removeAll()
        if let submitEvent = submitEvent {
            try await pushFormEvent(submitEvent)
        } else if let submitAction {
            submitAction()
        }
    }

    /// Create a URL encoded body from the data in the form.
    public func buildFormQuery() throws -> String {
        return try buildFormURLComponents().formEncodedQuery!
    }
    
    private func sendChangeEventForFormElement(_ value: any FormValue, for name: String, _ sendEvent: ((Any) async throws -> ())?) -> (() async throws -> Void)? {
        guard let event = sendEvent else { return nil }
                
        return {
            // LiveView expects all values to be strings.
            let encodedValue: String = if let value = value as? String {
                value
            } else {
                try value.formQueryEncoded()
            }
            
            var components = URLComponents()
            components.queryItems = [
                .init(name: name, value: encodedValue),
                .init(name: "_target", value: name)
            ]
            
            try await event(components.formEncodedQuery!)
        }
    }
    
    private func sendChangeEventForForm(for name: String, _ sendEvent: ((String) async throws -> Void)?) -> (() async throws -> Void)? {
        guard let event = sendEvent else { return nil }
        
        return {
            var components = try self.buildFormURLComponents()
            components.queryItems?.append(.init(name: "_target", value: name))
            
            try await event(components.formEncodedQuery!)
        }
    }
    
    public func buildFormURLComponents() throws -> URLComponents {
        let data = try data.mapValues { value in
            if let value = value as? String {
                return value
            } else {
                return try value.formQueryEncoded()
            }
        }

        var components = URLComponents()
        components.queryItems = data.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components
    }

    @MainActor
    private func pushFormEvent(_ event: String) async throws {
        // the `form` event type expects a URL encoded payload (e.g., `a=b&c=d`)
        _ = try await pushEventImpl("form", event, try buildFormQuery(), nil)
    }
    
    public nonisolated var debugDescription: String {
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
    }
    
    public func setValue(_ value: (some FormValue)?, forName name: String, changeEvent: Event.EventHandler?) {
        let existing = data[name]
        if let existing,
           let value,
           !existing.isEqual(to: value)
        {
            formFieldWillChange.send(name)
        } else if (existing != nil && value == nil) || (existing == nil && value != nil) {
            // something -> nil or nil -> something
            formFieldWillChange.send(name)
        } else {
            // nothing to do
            return
        }
        data[name] = value
        if changeEvent?.debounce != .blur,
           let value
        {
            Task {
                try await sendChangeEvent(value, for: name, event: changeEvent)
            }
        }
    }
    
    /// Set a value into the form's `data` without triggering change events.
    public func setServerValue(_ value: (some FormValue)?, forName name: String) {
        data[name] = value
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

    public func queueFileUpload(
        name: String,
        id: String,
        url: URL,
        coordinator: LiveViewCoordinator<some RootRegistry>
    ) async throws {
        let shouldRelinquishAccess = url.startAccessingSecurityScopedResource()
        defer {
            if shouldRelinquishAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
        return try await queueFileUpload(
            name: name,
            id: id,
            contents: try Data(contentsOf: url),
            fileType: UTType(filenameExtension: url.pathExtension)!,
            fileName: url.lastPathComponent,
            coordinator: coordinator
        )
    }
    
    public func queueFileUpload(
        name: String,
        id: String,
        contents: Data,
        fileType: UTType,
        fileName: String,
        coordinator: LiveViewCoordinator<some RootRegistry>
    ) async throws {
        guard let liveChannel = coordinator.liveChannel
        else { return }
        
        let file = LiveFile(
            contents,
            fileType.preferredMIMEType!,
            fileName,
            "",
            id
        )
        
        let ref = coordinator.nextUploadRef()
        
        let fileMetadata = Json.object(object: [
            "path": .str(string: name),
            "ref": .str(string: "\(ref)"),
            "last_modified": .numb(number: .posInt(pos: UInt64(Date().timeIntervalSince1970 * 1000))), // in milliseconds
            "name": .str(string: fileName),
            "relative_path": .str(string: ""),
            "type": .str(string: fileType.preferredMIMEType!),
            "size": .numb(number: .posInt(pos: UInt64(contents.count)))
        ])
        
        if let changeEventName {
            let replyPayload = try await coordinator.liveChannel!.channel().call(
                event: .user(user: "event"),
                payload: .jsonPayload(json: .object(object: [
                    "type": .str(string: "form"),
                    "event": .str(string: changeEventName),
                    "value": .str(string: "_target=\(name)"),
                    "uploads": .object(object: [
                        id: .array(array: [
                            fileMetadata
                        ])
                    ])
                ])),
                timeout: 10_000
            )
            try await coordinator.handleEventReplyPayload(replyPayload)
        }
        self.fileUploads.append(.init(
            id: id,
            data: contents,
            ref: ref,
            upload: {
                do {
                    let entries = Json.array(array: [
                        fileMetadata
                    ])
                    
                    let payload = LiveViewNativeCore.Payload.jsonPayload(json: .object(object: [
                        "ref": .str(string: id),
                        "entries": entries,
                    ]))
                    
                    print("sending preflight request \(ref)")
                    
                    let response = try await coordinator.liveChannel!.channel().call(
                        event: .user(user: "allow_upload"),
                        payload: payload,
                        timeout: 10_000
                    )
                    
                    try await coordinator.handleEventReplyPayload(response)
                    
                    print("got preflight response \(response)")
                    
                    // LiveUploader.initAdapterUpload
                    // UploadEntry.uploader
                    // utils.channelUploader
                    // EntryUploader
                    let reply = switch response {
                    case let .jsonPayload(json: json):
                        try await JsonDecoder().decode(AllowUploadReply.self, from: json)
                    default:
                        fatalError()
                    }
                    print(reply)
                    
                    let uploadChannel = try await coordinator.session.liveSocket!.socket().channel(topic: .fromString(topic: "lvu:\(ref)"), payload: .jsonPayload(json: .object(object: [
                        "token": .str(string: reply.entries["\(ref)"]!)
                    ])))
                    try await uploadChannel.join(timeout: 10_000)
                    
                    let stream = InputStream(data: contents)
                    var buf = [UInt8](repeating: 0, count: reply.config.chunk_size)
                    stream.open()
                    while case let amount = stream.read(&buf, maxLength: reply.config.chunk_size), amount > 0 {
                        let resp = try await uploadChannel.call(event: .user(user: "chunk"), payload: .binary(bytes: Data(buf[..<amount])), timeout: 10_000)
                        print("uploaded chunk: \(resp)")
                    }
                    stream.close()
                    
                    print("finished uploading chunks")
                    let progressReply = try await coordinator.liveChannel!.channel().call(
                        event: .user(user: "progress"),
                        payload: .jsonPayload(json: .object(object: [
                            "event": .null,
                            "ref": .str(string: id),
                            "entry_ref": .str(string: "\(ref)"),
                            "progress": .numb(number: .posInt(pos: 100)),
                        ])),
                        timeout: 10_000
                    )
                    print(progressReply)
                    try await coordinator.handleEventReplyPayload(progressReply)
                    
                    print("done")
                } catch {
                    fatalError(error.localizedDescription)
                }
                
//                try! await liveChannel.uploadFile(file)
            }
        ))
    }
    
    fileprivate struct UploadConfig: Codable {
        let chunk_size: Int
        let max_entries: Int
        let chunk_timeout: Int
        let max_file_size: Int
    }
    
    fileprivate struct AllowUploadReply: Codable {
        let ref: String
        let config: UploadConfig
        let entries: [String:String]
    }
}

private extension URLComponents {
    var formEncodedQuery: String? {
        var components = self
        components.queryItems = components.queryItems?.map({
            .init(
                name: $0.name,
                value: $0.value//.flatMap({ $0.addingPercentEncoding(withAllowedCharacters: .alphanumerics) })
            )
        })
        return components.query!
    }
}

