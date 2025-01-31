//
//  Event.swift
//  
//
//  Created by Carson.Katri on 2/28/23.
//

import SwiftUI
import Combine
import LiveViewNativeCore
import AsyncAlgorithms

/// A property wrapper that handles sending events to the server, with automatic debounce and throttle handling.
///
/// ## Stylesheets
/// Use the `event` helper to reference an event from a modifier.
///
/// ```swift
/// event("my-event-name")
/// ```
///
/// Handle this event from your LiveView.
///
/// ```elixir
/// def handle_event("my-event-name", _params, socket), do: ...
/// ```
///
/// You can also provide options for `debounce` and `throttle` (in milliseconds).
///
/// ```swift
/// event("my-event-name", debounce: 1000)
/// event("my-event-name", throttle: 500)
/// ```
///
/// ## Custom Elements
///
/// Specify the attribute that contains the event name and an event type to create the wrapper.
/// Then, call the wrapped value with a payload and optionally a completion handler.
///
/// ```swift
/// struct MyCounterElement: View {
///     @Event("on-increment", type: "click") private var increment
///
///     var body: some View {
///         MyCounterView(onIncrement: {
///             increment(["new-value": 10])
///         })
///     }
/// }
/// ```
///
/// The element should include an attribute with the name of the event to trigger.
///
/// ```html
/// <MyCounter on-increment="increment_count" />
/// ```
///
/// Any `phx-debounce` or `phx-throttle` attributes on this element will be respected automatically.
///
///## Topics
///### Initializers
///- ``init(_:type:)``
///- ``init(event:type:)``
///### Instance Properties
///- ``wrappedValue``
///### Supporting Types
///- ``EventHandler``
@MainActor
@propertyWrapper
public struct Event: @preconcurrency DynamicProperty, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
    @ObservedElement private var element: ElementNode
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment
    @Environment(\.eventConfirmation) private var eventConfirmation
    @StateObject var handler = Handler()
    /// The name of the event to send.
    @_documentation(visibility: public)
    private let event: String?
    private let name: AttributeName?
    /// The type of event, such as `click` or `focus`.
    @_documentation(visibility: public)
    private let type: String
    /// The target `LiveView` or `LiveComponent`.
    ///
    /// Pass `@myself` in a component to send the event to the component instead of its parent `LiveView`.
    @_documentation(visibility: public)
    private let target: Int?
    /// A duration in milliseconds for the debounce interval.
    ///
    /// - Note: ``debounce`` takes precedence over ``throttle``.
    @_documentation(visibility: public)
    private let debounce: Double?
    /// A duration in milliseconds for the throttle interval.
    ///
    /// - Note: ``debounce`` takes precedence over ``throttle``.
    @_documentation(visibility: public)
    private let throttle: Double?
    /// Custom values to send with the event.
    @_documentation(visibility: public)
    private let params: Any?
    
    var debounceAttribute: Debounce? {
        try? element.attributeValue(Debounce.self, for: "phx-debounce")
    }
    private var throttleAttribute: Double? {
        try? element.attributeValue(Double.self, for: "phx-throttle")
    }
    
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self.init(AttributeName(rawValue: value)!, type: "click")
    }
    
    enum Debounce: AttributeDecodable, Equatable {
        /// Only send when the input loses focus.
        /// Handled by `@FormState` and `@ChangeTracked`, with the individual form controls indicating when they lose focus.
        case blur
        case milliseconds(Double)
        
        init(from attribute: Attribute?, on element: ElementNode) throws {
            if attribute?.value == "blur" {
                self = .blur
            } else {
                self = .milliseconds(try Double(from: attribute, on: element))
            }
        }
        
        var milliseconds: Double? {
            guard case let .milliseconds(milliseconds) = self else { return nil }
            return milliseconds
        }
    }
    
    @MainActor
    final class Handler: ObservableObject {
        let channel = AsyncChannel<EventPayload>()
        
        struct EventPayload: @unchecked Sendable {
            let type: String
            let event: String
            let payload: Any
            let target: Int?
        }
        
        private var handlerTask: Task<(), Error>?
        
        private var debounce: Double?
        var throttle: Double?
        
        let didSendSubject = PassthroughSubject<Void, Never>()
        
        init() {}
        
        deinit {
            self.handlerTask?.cancel()
        }
        
        func update(coordinator: CoordinatorEnvironment?, debounce: Double?, throttle: Double?) {
            guard handlerTask == nil || debounce != self.debounce || throttle != self.throttle
            else { return }
            handlerTask?.cancel()
            self.debounce = debounce
            self.throttle = throttle
            let pushEvent = coordinator?.pushEvent
            if let debounce = debounce {
                handlerTask = Task { [weak channel, weak didSendSubject, pushEvent] in
                    guard let channel else { return }
                    for await event in channel.debounce(for: .milliseconds(debounce)) {
                        _ = try await pushEvent?(event.type, event.event, event.payload, event.target)
                        didSendSubject?.send()
                    }
                }
            } else if let throttle = throttle {
                handlerTask = Task { @MainActor [weak channel, weak didSendSubject, pushEvent] in
                    guard let channel else { return }
                    for await event in channel._throttle(for: .milliseconds(throttle)) {
                        _ = try await pushEvent?(event.type, event.event, event.payload, event.target)
                        didSendSubject?.send()
                    }
                }
            } else {
                handlerTask = Task { @MainActor [weak channel, weak didSendSubject, pushEvent] in
                    guard let channel else { return }
                    for await event in channel {
                        _ = try await pushEvent?(event.type, event.event, event.payload, event.target)
                        didSendSubject?.send()
                    }
                }
            }
        }
    }
    
    /// Retrieves the event name from a specific attribute.
    ///
    /// A `Button` may handle the `phx-click` event.
    /// ```html
    /// <Button phx-click="my_event_name" />
    /// ```
    /// Using this initializer, the event name would be identified by the value of the `phx-click` attribute:
    /// ```swift
    /// @Event("phx-click", type: "click") private var click
    /// ```
    public init(_ name: AttributeName, type: String) {
        self.event = nil
        self.name = name
        self.type = type
        self.target = nil
        self.debounce = nil
        self.throttle = nil
        self.params = nil
    }
    
    /// Creates a binding to a known server-side event name.
    ///
    /// Unlike ``init(_:type:)``, which identifies the event name from an attribute, this initializer has a static event name specified.
    /// ```swift
    /// @Event(event: "my_event_name", type: "click") private var click
    /// ```
    /// The event name is no longer defined by the client, but instead uses the value passed in here.
    public init(event: String, type: String, debounce: Double? = nil, throttle: Double? = nil, element: ElementNode? = nil) {
        self.event = event
        self.name = nil
        self.type = type
        self.target = nil
        self.debounce = debounce
        self.throttle = throttle
        self.params = nil
        self._element = element.flatMap({ .init(element: $0) }) ?? .init()
    }
    
    /// Create a `nil` event.
    public init() {
        self.event = nil
        self.name = nil
        self.type = "click"
        self.target = nil
        self.debounce = nil
        self.throttle = nil
        self.params = nil
    }
    
    /// Create an event reference as an argument to a modifier.
    ///
    /// For simple events, pass a string value.
    ///
    /// ```elixir
    /// "my_event_name"
    /// ```
    ///
    /// ```elixir
    /// def handle_event("my_event_name", _params, socket) do
    ///   ...
    /// end
    /// ```
    ///
    /// Other arguments can be passed by using a map.
    ///
    /// ```elixir
    /// %{
    ///   :event => "my_event_name"
    ///   :type => "click"
    ///   :params => %{
    ///     "custom_value" => "this is my own value"
    ///   },
    ///   :target => @myself,
    ///   :debounce => 1000,
    ///   :throttle => 1000
    /// }
    /// ```
    ///
    /// ## Arguments
    /// * ``event``
    /// * ``type``
    /// * ``params``
    /// * ``target``
    /// * ``debounce``
    /// * ``throttle``
    public init(from decoder: Decoder) throws {
        if let singleValue = try? decoder.singleValueContainer(),
           singleValue.decodeNil()
        {
            self.event = nil
            self.name = nil
            self.type = "click"
            self.target = nil
            self.debounce = nil
            self.throttle = nil
            self.params = nil
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.event = try container.decodeIfPresent(String.self, forKey: .event)
            self.name = nil
            self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? "click"
            self.target = try container.decodeIfPresent(Int.self, forKey: .target)
            self.debounce = try container.decodeIfPresent(Double.self, forKey: .debounce)
            self.throttle = try container.decodeIfPresent(Double.self, forKey: .throttle)
            self.params = try container.decodeIfPresent(String.self, forKey: .params).flatMap({ try? JSONSerialization.jsonObject(with: Data($0.utf8)) })
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case event
        case type
        case target
        case debounce
        case throttle
        case params
    }
    
    /// Sends the event with a given payload and completion handler.
    ///
    /// After declaring an event, call the `wrappedValue` with a JSON-encodable payload and optionally a completion handler.
    /// ```swift
    /// @Event("phx-click", type: "click") private var click
    ///
    /// click(value: ["count": clickCount]) {
    ///     print("Event completed")
    /// }
    /// ```
    public var wrappedValue: EventHandler {
        EventHandler(owner: self)
    }
    
    /// A closure that triggers the event without any additional payload or waiting for completion.
    public var projectedValue: () -> Void {
        return { wrappedValue() }
    }
    
    public func update() {
        handler.update(coordinator: coordinatorEnvironment, debounce: debounce ?? debounceAttribute?.milliseconds, throttle: throttle ?? throttleAttribute)
    }
    
    /// An action that you invoke to send an event to the server.
    @MainActor
    public struct EventHandler {
        let owner: Event
        
        var event: String? {
            owner.event ?? owner.name.flatMap(owner.element.attributeValue(for:))
        }
        
        public func callAsFunction(value: Any = [String:String](), didSend: (() -> Void)? = nil) {
            Task {
                try await self.callAsFunction(value: value)
                didSend?()
            }
        }
        
        public func callAsFunction(value: Any = [String:String]()) async throws {
            guard let event else {
                return
            }
            if let confirm = try owner.element.attributeValue(for: "data-confirm"),
               let eventConfirmation = owner.eventConfirmation
            {
                guard await eventConfirmation(confirm, owner.element) else { return }
            }
            await owner.handler.channel.send(.init(
                type: owner.type,
                event: event,
                payload: owner.params ?? value,
                target: owner.target ?? owner.element.attributeValue(for: "phx-target").flatMap(Int.init)
            ))
        }
        
        public func callAsFunction<R: RootRegistry>(value: Any = [String:String](), in context: LiveContext<R>) async throws {
            guard let event else {
                return
            }
            if let confirm = try owner.element.attributeValue(for: "data-confirm"),
               let eventConfirmation = owner.eventConfirmation
            {
                guard await eventConfirmation(confirm, owner.element) else { return }
            }
            let handler = Handler()
            handler.update(
                coordinator: CoordinatorEnvironment(context.coordinator, document: context.coordinator.document!),
                debounce: owner.debounce,
                throttle: owner.throttle
            )
            await handler.channel.send(.init(
                type: owner.type,
                event: event,
                payload: owner.params ?? value,
                target: owner.target
            ))
        }
    }
}

extension EnvironmentValues {
    private enum EventConfirmationKey: EnvironmentKey {
        static var defaultValue: ((String, ElementNode) async -> Bool)? { nil }
    }
    
    var eventConfirmation: ((String, ElementNode) async -> Bool)? {
        get { self[EventConfirmationKey.self] }
        set { self[EventConfirmationKey.self] = newValue }
    }
}
