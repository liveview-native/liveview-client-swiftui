//
//  CGAffineTransform.swift
//  
//
//  Created by Carson Katri on 5/16/23.
//

import CoreFoundation

/// A transformation matrix.
///
/// Affine transforms are represented by a 3×3 matrix.
///
/// ```
/// a  b  0
/// c  d  0
/// tx ty 1
/// ```
///
/// The third column is always `{0, 0, 1}`, and is therefore excluded from operations.
///
/// ## Operations
/// Create a transform with an operation to easily make the matrix.
///
/// ### :translate
/// Creates a matrix that moves an element.
///
/// ```elixir
/// {:translate, {x, y}}
/// ```
///
/// ### :scale
/// Create a matrix that resizes an element by a factor.
///
/// ```elixir
/// {:scale, {x, y}}
/// {:scale, factor}
/// ```
///
/// ### :rotate
/// Creates a matrix that rotates an element with an ``LiveViewNative/SwiftUI/Angle``.
///
/// ```elixir
/// {:rotate, {:degrees, angle}}
/// {:rotate, {:radians, angle}}
/// ```
///
/// ### :identity
/// Provides the identity matrix:
///
/// ```
/// 1  0  0
/// 0  1  0
/// 0  0  1
/// ```
///
/// ## Combining Transformations
/// Provide an array of transformations to concatenate them.
///
/// ```elixir
/// [
///   {:translate, {50, 0}}, # move right 50
///   {:rotate, {:degrees, 45}}, # rotate 45º
///   {:scale, 0.5} # scale to 50%
/// ]
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension CoreFoundation.CGAffineTransform {
    // DocC crashes when documentation is applied to an empty extension.
    var ___: Never { fatalError() }
}
