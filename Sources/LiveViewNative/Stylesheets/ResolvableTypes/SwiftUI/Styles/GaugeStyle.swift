//
//  GaugeStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("GaugeStyle")
enum StylesheetResolvableGaugeStyle: @preconcurrency GaugeStyle, StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    case circular
    case accessoryCircular
    case accessoryCircularCapacity
    case linear
    case linearCapacity
    case accessoryLinear
    case accessoryLinearCapacity
}

extension StylesheetResolvableGaugeStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            DefaultGaugeStyle().makeBody(configuration: configuration)
        case .circular:
            AccessoryCircularGaugeStyle().makeBody(configuration: configuration)
        case .accessoryCircular:
            AccessoryCircularGaugeStyle().makeBody(configuration: configuration)
        case .accessoryCircularCapacity:
            AccessoryCircularCapacityGaugeStyle().makeBody(configuration: configuration)
        case .linear:
            AccessoryLinearGaugeStyle().makeBody(configuration: configuration)
        case .linearCapacity:
            LinearCapacityGaugeStyle().makeBody(configuration: configuration)
        case .accessoryLinear:
            AccessoryLinearGaugeStyle().makeBody(configuration: configuration)
        case .accessoryLinearCapacity:
            AccessoryLinearCapacityGaugeStyle().makeBody(configuration: configuration)
        }
    }
}

extension StylesheetResolvableGaugeStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "circular":
            self = .circular
        case "accessoryCircular":
            self = .accessoryCircular
        case "accessoryCircularCapacity":
            self = .accessoryCircularCapacity
        case "linear":
            self = .linear
        case "linearCapacity":
            self = .linearCapacity
        case "accessoryLinear":
            self = .accessoryLinear
        case "accessoryLinearCapacity":
            self = .accessoryLinearCapacity
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
