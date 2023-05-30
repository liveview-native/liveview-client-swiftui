//
//  ProjectionTransform.swift
//  
//
//  Created by Carson Katri on 5/24/23.
//

import SwiftUI

/// A 3D transformation matrix.
///
/// 3D transforms are represented by a 4×4 matrix.
///
/// ## Operations
/// Create a transform with an operation to easily make the matrix.
///
/// ### :translate
/// Creates a matrix that moves an element.
///
/// ```elixir
/// {:translate, {x, y, z}}
/// ```
///
/// ### :scale
/// Create a matrix that resizes an element by a factor.
///
/// ```elixir
/// {:scale, {x, y, z}}
/// {:scale, factor}
/// ```
///
/// ### :rotate
/// Creates a matrix that rotates an element with an ``LiveViewNative/SwiftUI/Angle`` about a vector.
///
/// ```elixir
/// {:rotate, {:degrees, angle}, {x, y, z}}
/// {:rotate, {:radians, angle}, {x, y, z}}
/// ```
///
/// ### :identity
/// Provides the identity matrix:
///
/// ```
/// 1  0  0  0
/// 0  1  0  0
/// 0  0  1  0
/// 0  0  0  1
/// ```
///
/// ## Combining Transformations
/// Provide an array of transformations to concatenate them.
///
/// ```elixir
/// [
///   {:translate, {50, 0, 10}}, # move right 50, forward 10
///   {:rotate, {:degrees, 45}, {0, 0, 1}}, # rotate 45º around the Z axis
///   {:scale, 0.5} # scale to 50%
/// ]
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
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
