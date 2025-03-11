//
//  Accessibility.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import Accessibility
import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

extension Accessibility.AXCustomContent.Importance {
    @ASTDecodable("Importance")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(Accessibility.AXCustomContent.Importance)
        
        case `default`
        case high
    }
}

public extension Accessibility.AXCustomContent.Importance.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Accessibility.AXCustomContent.Importance {
        switch self {
        case let .__constant(value):
            return value
        case .default:
            return .default
        case .high:
            return .high
        }
    }
}

public struct StylesheetResolvableAXChartDescriptorRepresentable: StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AXChartDescriptorRepresentable {
    public init(from decoder: any Decoder) throws {
        fatalError("'AXChartDescriptor' is not supported")
    }
    
    public func makeChartDescriptor() -> AXChartDescriptor {
        fatalError("'AXChartDescriptor' is not supported")
    }
    
    public func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        return self
    }
}

extension StylesheetResolvableAXChartDescriptorRepresentable: @preconcurrency AttributeDecodable {
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError("'AXChartDescriptor' is not supported")
    }
}
