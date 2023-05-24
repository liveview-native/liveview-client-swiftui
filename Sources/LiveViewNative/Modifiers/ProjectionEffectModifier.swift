//
//  ProjectionEffectModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/23/2023.
//

import SwiftUI

/// <#Documentation#>
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ProjectionEffectModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// <#Documentation#>
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let transform: ProjectionTransform

    func body(content: Content) -> some View {
        content.projectionEffect(transform)
    }
}

extension ProjectionTransform: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        #if os(watchOS)
        var values = [CGFloat]()
        while !container.isAtEnd {
            values.append(try container.decode(CGFloat.self))
        }
        self.init(CGAffineTransform(
            a: values[0], b: values[1],
            c: values[4], d: values[5],
            tx: values[8], ty: values[9]
        ))
        #else
        self.init(CATransform3D(
            m11: try container.decode(CGFloat.self),
            m12: try container.decode(CGFloat.self),
            m13: try container.decode(CGFloat.self),
            m14: try container.decode(CGFloat.self),
            m21: try container.decode(CGFloat.self),
            m22: try container.decode(CGFloat.self),
            m23: try container.decode(CGFloat.self),
            m24: try container.decode(CGFloat.self),
            m31: try container.decode(CGFloat.self),
            m32: try container.decode(CGFloat.self),
            m33: try container.decode(CGFloat.self),
            m34: try container.decode(CGFloat.self),
            m41: try container.decode(CGFloat.self),
            m42: try container.decode(CGFloat.self),
            m43: try container.decode(CGFloat.self),
            m44: try container.decode(CGFloat.self)
        ))
        #endif
    }
}
