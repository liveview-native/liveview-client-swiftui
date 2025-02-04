//
//  QuartzCore.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import QuartzCore
import LiveViewNativeStylesheet

extension CATransform3D {
    @ASTDecodable("CATransform3D")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CATransform3D)
    }
}

extension CATransform3D.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CATransform3D {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}
