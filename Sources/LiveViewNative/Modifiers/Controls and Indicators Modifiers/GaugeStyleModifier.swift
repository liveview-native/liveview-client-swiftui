//
//  GaugeStyleModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/4/23.
//

import SwiftUI

/// Alters the visual style of any gauges within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``GaugeStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, watchOS 9.0, macOS 13.0, *)
struct GaugeStyleModifier: ViewModifier, Decodable {
    /// The style to apply to gauges.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: GaugeStyle
    
    func body(content: Content) -> some View {
        #if !os(tvOS)
        switch style {
        case .accessoryCircularCapacity:
            content.gaugeStyle(.accessoryCircularCapacity)
        case .accessoryLinearCapacity:
            content.gaugeStyle(.accessoryLinearCapacity)
        case .accessoryCircular:
            content.gaugeStyle(.accessoryCircular)
        case .automatic:
            content.gaugeStyle(.automatic)
        case .linearCapacity:
            content.gaugeStyle(.linearCapacity)
        case .accessoryLinear:
            content.gaugeStyle(.accessoryLinear)
        }
        #else
        content
        #endif
    }
}

/// A style for a ``Gauge`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum GaugeStyle: String, Decodable {
    /// `accessory_circular_capacity`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case accessoryCircularCapacity = "accessory_circular_capacity"
    /// `accessory_linear_capacity`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case accessoryLinearCapacity = "accessory_linear_capacity"
    /// `accessory_circular`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case accessoryCircular = "accessory_circular"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    /// `linear_capacity`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case linearCapacity = "linear_capacity"
    /// `accessory_linear`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case accessoryLinear = "accessory_linear"
}
