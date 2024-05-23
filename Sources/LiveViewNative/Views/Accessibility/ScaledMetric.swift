//
//  ScaledMetric.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/30/23.
//

import SwiftUI

/// Tracks changed to the dynamic type size in the current context.
///
/// Use this element to scale a value with the accessibility dynamic type size.
///
/// ```html
/// <ScaledMetric phx-change="scaled-value-changed" value={100} relativeTo="largeTitle">
///   <Image systemName="heart" class="resizable frame-attr" frame={@scaled_value}>
/// </ScaledMetric>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.AccessibilityLive do
///   def handle_event("scaled-value-changed", scaled_value, socket) do
///     {:noreply, assign(socket, scaled_value: scaled_value)}
///   end
/// end
/// ```
///
/// The initial ``value`` of `100` will be used when dynamic type is disabled.
/// If the dynamic type size is changed, the event referenced by `phx-change` will be updated with a scaled version of ``value``.
///
/// Optionally provide a ``LiveViewNative/SwiftUI/Font/TextStyle`` to scale relative to with the ``relativeStyle`` attribute.
///
/// ## Attributes
/// * ``value``
/// * ``relativeStyle``
///
/// ## Bindings
/// * ``scaledValue``
@_documentation(visibility: public)
@LiveElement
struct ScaledMetric<Root: RootRegistry>: View {
    /// The event to update with the scaled ``value``.
    @_documentation(visibility: public)
    @Event("phx-change", type: "click") private var onChange
    
    /// The initial value to scale.
    @_documentation(visibility: public)
    private var value: Double = 0
    
    /// The ``LiveViewNative/SwiftUI/Font/TextStyle`` to scale with.
    /// Defaults to `body`.
    @_documentation(visibility: public)
    @LiveAttribute(.init(name: "relativeTo")) private var relativeStyle: Font.TextStyle = .body
    
    var body: some View {
        ScaledMetricObserver(
            scaledMetric: .init(wrappedValue: value, relativeTo: relativeStyle),
            onChange: onChange,
            content: $liveElement.children()
        )
    }
    
    private struct ScaledMetricObserver<Content: View>: View {
        let scaledMetric: SwiftUI.ScaledMetric<Double>
        let onChange: Event.EventHandler
        let content: Content
        
        var body: some View {
            content
                .task(id: scaledMetric.wrappedValue) {
                    onChange(value: scaledMetric.wrappedValue)
                }
        }
    }
}
