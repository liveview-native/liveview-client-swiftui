//
//  ShapeStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("ShapeStyle")
struct StylesheetResolvableShapeStyle: StylesheetResolvable, ShapeStyle {
    typealias Resolved = AnyShapeStyle
}

extension StylesheetResolvableShapeStyle {
    func resolve(in environment: EnvironmentValues) -> AnyShapeStyle {
        return AnyShapeStyle(.red)
    }
    
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved {
        return AnyShapeStyle(.red)
    }
}

extension StylesheetResolvableShapeStyle: AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
