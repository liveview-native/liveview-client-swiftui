//
//  AnyShapeStyle.swift
// LiveViewNative
//
//  Created by Carson Katri on 2/7/23.
//

import SwiftUI

extension AnyShapeStyle {
    public init?(named name: String) {
        switch name {
        // HierarchicalShapeStyle
        case "primary":
            self = .init(HierarchicalShapeStyle.primary)
        case "secondary":
            self = .init(HierarchicalShapeStyle.secondary)
        case "tertiary":
            self = .init(HierarchicalShapeStyle.tertiary)
        case "quaternary":
            self = .init(HierarchicalShapeStyle.quaternary)
        
        // Foreground/Background
        case "foreground":
            self = .init(ForegroundStyle.foreground)
        case "background":
            self = .init(BackgroundStyle.background)

        default:
            if let color = Color(fromNamedOrCSSHex: name) {
                self = .init(color)
            } else {
                return nil
            }
        }
    }
}
