//
//  Spatial.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import Spatial
import LiveViewNativeStylesheet

extension Spatial.Size3D {
    @ASTDecodable("Size3D")
    @MainActor
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(Spatial.Size3D)
        case _init(width: AttributeReference<Double>, height: AttributeReference<Double>, depth: AttributeReference<Double>)
        
        init(width: AttributeReference<Double>, height: AttributeReference<Double>, depth: AttributeReference<Double>) {
            self = ._init(width: width, height: height, depth: depth)
        }
    }
}

public extension Spatial.Size3D.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Spatial.Size3D {
        switch self {
        case let .__constant(value):
            return value
        case let ._init(width, height, depth):
            return .init(
                width: width.resolve(on: element, in: context),
                height: height.resolve(on: element, in: context),
                depth: depth.resolve(on: element, in: context)
            )
        }
    }
}
