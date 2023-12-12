//
//  AnyGaugeStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
enum AnyGaugeStyle: String, CaseIterable, ParseableModifierValue, GaugeStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case accessoryCircular
    case accessoryCircularCapacity
    case linearCapacity
    case accessoryLinear
    case accessoryLinearCapacity
    #if os(watchOS)
    case circular
    case linear
    #endif
    
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            DefaultGaugeStyle().makeBody(configuration: configuration)
        case .accessoryCircular:
            AccessoryCircularGaugeStyle().makeBody(configuration: configuration)
        case .accessoryCircularCapacity:
            AccessoryCircularCapacityGaugeStyle().makeBody(configuration: configuration)
        case .linearCapacity:
            LinearCapacityGaugeStyle().makeBody(configuration: configuration)
        case .accessoryLinear:
            AccessoryLinearGaugeStyle().makeBody(configuration: configuration)
        case .accessoryLinearCapacity:
            AccessoryLinearCapacityGaugeStyle().makeBody(configuration: configuration)
        #if os(watchOS)
        case .circular:
            CircularGaugeStyle().makeBody(configuration: configuration)
        case .linear:
            LinearGaugeStyle().makeBody(configuration: configuration)
        #endif
        }
    }
}
#endif
