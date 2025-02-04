//
//  ShapeStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

enum StylesheetResolvableShapeStyle: StylesheetResolvable, @preconcurrency ShapeStyle, @preconcurrency Decodable {
    typealias Resolved = AnyShapeStyle
    
    case color(Color.Resolvable)
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.singleValueContainer()
        
        if let color = try? container.decode(Color.Resolvable.self) {
            self = .color(color)
            return
        }
        
        throw MultipleFailures([])
    }
}

extension StylesheetResolvableShapeStyle {
    func resolve(in environment: EnvironmentValues) -> AnyShapeStyle {
        return AnyShapeStyle(.red)
    }
    
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved {
        switch self {
        case let .color(color):
            return AnyShapeStyle(color.resolve(on: element, in: context))
        }
    }
}

extension StylesheetResolvableShapeStyle: @preconcurrency AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
