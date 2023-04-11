//
//  Event.swift
//  
//
//  Created by Carson.Katri on 2/28/23.
//

import SwiftUI
import Combine
import LiveViewNativeCore

/// A property wrapper that handles sending events to the server, with automatic debounce and throttle handling.
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
@propertyWrapper
public struct Event: DynamicProperty, Decodable {
    @ObservedElement private var element: ElementNode
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment
    @StateObject private var handler = Handler()
    /// The name of the event to send.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let event: String?
    private let name: AttributeName?
    /// The type of event, such as `click` or `focus`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let type: String
    /// The target `LiveView` or `LiveComponent`.
    ///
    /// Pass `@myself` in a component to send the event to the component instead of its parent `LiveView`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let target: Int?
    /// A duration in milliseconds for the debounce interval.
    ///
    /// - Note: ``debounce`` takes precedence over ``throttle``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let debounce: Double?
    /// A duration in milliseconds for the throttle interval.
    ///
    /// - Note: ``debounce`` takes precedence over ``throttle``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let throttle: Double?
    /// Custom values to send with the event.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let params: Any?
    
    @Attribute("phx-debounce") private var debounceAttribute: Double?
    @Attribute("phx-throttle") private var throttleAttribute: Double?
    
    final class Handler: ObservableObject {
        let currentEvent = PassthroughSubject<(() -> ())?, Never>()
        
        private var cancellable: AnyCancellable?

        private var cancellables = Set<AnyCancellable>()
        
        private var debounce: Double?
        var throttle: Double?
        
        init() {}
        
        func update(debounce: Double?, throttle: Double?) {
            guard cancellable == nil || debounce != self.debounce || throttle != self.throttle
            else { return }
            self.debounce = debounce
            self.throttle = throttle
            if let debounce = debounce {
                cancellable = currentEvent
                    .debounce(for: .init(debounce / 1000), scheduler: RunLoop.main)
                    .sink(receiveValue: { value in
                        value?()
                    })
            } else if let throttle = throttle {
                cancellable = currentEvent
                    .throttle(for: .init(throttle / 1000), scheduler: RunLoop.main, latest: true)
                    .sink(receiveValue: { value in
                        value?()
                    })
            } else {
                cancellable = currentEvent
                    .sink(receiveValue: { value in
                        value?()
                    })
            }
        }
    }
    
    /// Retrieves the event name from a specific attribute.
    ///
    /// A `Button` may handle the `phx-click` event.
    /// ```html
    /// <button phx-click="my_event_name" />
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
    public init(event: String, type: String) {
        self.event = event
        self.name = nil
        self.type = type
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.event = try container.decode(String.self, forKey: .event)
        self.name = nil
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? "click"
        self.target = try container.decodeIfPresent(Int.self, forKey: .target)
        self.debounce = try container.decodeIfPresent(Double.self, forKey: .debounce)
        self.throttle = try container.decodeIfPresent(Double.self, forKey: .throttle)
        self.params = try container.decodeIfPresent(String.self, forKey: .params).flatMap({ try? JSONSerialization.jsonObject(with: Data($0.utf8)) })
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
    
    public func update() {
        handler.update(debounce: debounce ?? debounceAttribute, throttle: throttle ?? throttleAttribute)
    }
    
    /// An action that you invoke to send an event to the server.
    @MainActor
    public struct EventHandler {
        let owner: Event
        
        public func callAsFunction(value: Any, didSend: (() -> Void)? = nil) {
            Task {
                try await self.callAsFunction(value: value)
                didSend?()
            }
        }
        
        public func callAsFunction(value: Any = [String:String]()) async throws {
            guard let event = owner.event ?? owner.name.flatMap(owner.element.attributeValue(for:)) else {
                return
            }
            try await withCheckedThrowingContinuation { continuation in
                owner.handler.currentEvent.send({
                    Task {
                        do {
                            try await owner.coordinatorEnvironment?.pushEvent(owner.type, event, owner.params ?? value, owner.target ?? owner.element.attributeValue(for: "phx-target").flatMap(Int.init))
                            continuation.resume()
                        } catch {
                            continuation.resume(with: .failure(error))
                        }
                    }
                })
            }
        }
    }
}
