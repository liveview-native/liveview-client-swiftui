//
//  Accessibility.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import Accessibility
import LiveViewNativeStylesheet

extension Accessibility.AXCustomContent.Importance {
    @ASTDecodable("Importance")
    enum Resolvable: StylesheetResolvable {
        case __constant(Accessibility.AXCustomContent.Importance)
        
        case `default`
        case high
    }
}

extension Accessibility.AXCustomContent.Importance.Resolvable {
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
