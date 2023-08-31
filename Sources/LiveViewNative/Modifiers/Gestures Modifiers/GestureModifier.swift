//
//  OnTapGestureModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/20/2023.
//

import SwiftUI

/// Sends an event when a gesture is performed on the element.
///
/// - Note: Use the `phx-click` attribute to easily handle tap events.
///
/// Pass in a ``gesture`` and an event name.
///
/// ```html
/// <Rectangle modifiers={gesture(:spatial_tap, action: "on_tap")} />
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.GestureLive do
///   def handle_event("on_tap", %{ "x" => x, "y" => y }, socket) do
///     {:noreply, assign(socket, :location, [x, y])}
///   end
/// end
/// ```
///
/// See ``LiveViewNative/SwiftUI/AnyGesture`` for details on creating gestures.
///
/// ## Arguments
/// * ``gesture``
/// * ``action``
/// * ``mask``
/// * ``priority``
///
/// ## Topics
/// ### Supporting Types
/// * ``LiveViewNative/SwiftUI/AnyGesture``
/// * ``GesturePriority``
/// * ``LiveViewNative/SwiftUI/GestureMask``
/// * ``Event``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GestureModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The gesture to observe.
    ///
    /// See ``LiveViewNative/SwiftUI/AnyGesture`` for details on creating gestures.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let gesture: AnyGesture<Any>
    
    /// The event to trigger when tapped.
    ///
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event private var action: Event.EventHandler
    
    /// The priority of the gesture. Defaults to `low`.
    ///
    /// See ``GesturePriority`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let priority: GesturePriority
    
    /// Controls how this gestures impacts other gestures on the element and its children. Defaults to `all`.
    ///
    /// See ``LiveViewNative/SwiftUI/GestureMask`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let mask: GestureMask

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.gesture = try container.decode(AnyGesture<Any>.self, forKey: .gesture)
        self._action = try container.decode(Event.self, forKey: .action)
        self.priority = try container.decode(GesturePriority.self, forKey: .priority)
        self.mask = try container.decode(GestureMask.self, forKey: .mask)
    }

    func body(content: Content) -> some View {
        let gesture = self.gesture
            .onEnded { value in
                self.action(value: value)
            }
        switch priority {
        case .low:
            content.gesture(gesture, including: mask)
        case .high:
            content.highPriorityGesture(gesture, including: mask)
        case .simultaneous:
            content.simultaneousGesture(gesture, including: mask)
        }
    }

    enum CodingKeys: String, CodingKey {
        case gesture
        case action
        case priority
        case mask
    }
}

/// The priority of a gesture.
///
/// Possible values:
/// * ``low``
/// * ``high``
/// * ``simultaneous``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
enum GesturePriority: String, Decodable {
    /// Gives precedence to system gestures.
    ///
    /// ```html
    /// <Button
    ///     phx-click="button_event"
    ///     modifiers={gesture(:tap, action: "gesture_event", priority: :low)}
    /// >
    ///     Button Event Only
    /// </Button>
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case low
    /// Takes precedence over system gestures.
    ///
    /// ```html
    /// <Button
    ///     phx-click="button_event"
    ///     modifiers={gesture(:tap, action: "gesture_event", priority: :high)}
    /// >
    ///     Gesture Event Only
    /// </Button>
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case high
    /// Performs alongside system gestures.
    ///
    /// ```html
    /// <Button
    ///     phx-click="button_event"
    ///     modifiers={gesture(:tap, action: "gesture_event", priority: :simultaneous)}
    /// >
    ///     Button and Gesture Events
    /// </Button>
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case simultaneous
}
