//
//  ScaledMetric.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/30/23.
//

import SwiftUI

/// Updates a binding based on the dynamic type size in the current context.
///
/// Use this element to scale a value with the accessibility dynamic type size.
///
/// ```html
/// <ScaledMetric scaled-value-binding={:scaled_value} value={100} relative-to="large-title">
///   <Image system-name="heart" resizable modifiers={frame(@native, width: @scaled_value, height: @scaled_value)}>
/// </ScaledMetric>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.AccessibilityLive do
///   native_binding :scaled_value, Float, 100.0
/// end
/// ```
///
/// The initial ``value`` of `100` will be used when dynamic type is disabled.
/// If the dynamic type size is changed, the binding referenced by ``scaledValue`` will be updated with a scaled version of ``value``.
///
/// Optionally provide a ``LiveViewNative/SwiftUI/Font/TextStyle`` to scale relative to with the ``relativeStyle`` attribute.
///
/// ## Attributes
/// * ``value``
/// * ``relativeStyle``
///
/// ## Bindings
/// * ``scaledValue``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ScaledMetric<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The binding to update with the scaled ``value``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding(attribute: "scaled-value-binding") private var scaledValue: Double
    
    /// The initial value to scale.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("value") private var value: Double
    
    /// The ``LiveViewNative/SwiftUI/Font/TextStyle`` to scale with.
    /// Defaults to `body`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("relative-to") private var relativeStyle: Font.TextStyle = .body
    
    var body: some View {
        ScaledMetricObserver(
            scaledMetric: .init(wrappedValue: value, relativeTo: relativeStyle),
            value: $scaledValue,
            content: context.buildChildren(of: element)
        )
    }
    
    private struct ScaledMetricObserver<Content: View>: View {
        let scaledMetric: SwiftUI.ScaledMetric<Double>
        @Binding var value: Double
        let content: Content
        
        var body: some View {
            content
                .task(id: scaledMetric.wrappedValue) {
                    value = scaledMetric.wrappedValue
                }
        }
    }
}
