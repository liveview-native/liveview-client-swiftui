//
//  ProjectionTransform+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ProjectionTransform`](https://developer.apple.com/documentation/swiftui/ProjectionTransform) for more details.
///
/// Use a ``CoreGraphics/CGAffineTransform`` to build a transformation matrix.
///
/// ```swift
/// .identity
/// CGAffineTransform(rotationAngle: 5)
/// CGAffineTransform(scaleX: 0.5, y: 1.5)
/// CGAffineTransform(translationX: 5, y: 10)
/// ```
@_documentation(visibility: public)
extension ProjectionTransform: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        CGAffineTransform.parser(in: context).map(Self.init(_:))
    }
}

/// See [`CoreFoundation.CGAffineTransform`](https://developer.apple.com/documentation/corefoundation/CGAffineTransform) for more details.
///
/// Build a matrix with custom values or a preset transformation.
///
/// ### Custom Matrices
/// Affine transforms are represented with a 3x3 matrix.
///
/// ```
/// a  b  0
/// c  d  0
/// tx ty 1
/// ```
///
/// Pass the values for `a`, `b`, `c`, `d`, `tx`, and `ty` to build a custom transformation matrix.
///
/// ```swift
/// CGAffineTransform(1, 0, 0, 1, 0, 0)
/// ```
///
/// ### Rotation Matrix
/// Pass a `rotationAngle` in radians to build a rotation matrix.
///
/// ```swift
/// CGAffineTransform(rotationAngle: 5)
/// CGAffineTransform(rotationAngle: 3.14)
/// ```
///
/// ### Scale Matrix
/// Pass a `scaleX` and `y` to build a scale matrix.
///
/// ```swift
/// CGAffineTransform(scaleX: 0.5, y: 1.5)
/// ```
///
/// ### Translation Matrix
/// Pass a `translationX` and `y` to build a translation matrix.
///
/// ```swift
/// CGAffineTransform(translationX: 5, y: 10)
/// ```
@_documentation(visibility: public)
extension CGAffineTransform: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _CGAffineTransform.parser(in: context).map(\.value)
            ImplicitStaticMember(["identity": .identity])
        }
    }
    
    @ASTDecodable("CGAffineTransform")
    struct _CGAffineTransform {
        let value: CGAffineTransform
        
        init(_ a: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat, _ tx: CGFloat, _ ty: CGFloat) {
            self.value = .init(a, b, c, d, tx, ty)
        }
        
        init(rotationAngle: CGFloat) {
            self.value = .init(rotationAngle: rotationAngle)
        }
        
        init(scaleX: CGFloat, y: CGFloat) {
            self.value = .init(scaleX: scaleX, y: y)
        }
        
        init(translationX: CGFloat, y: CGFloat) {
            self.value = .init(translationX: translationX, y: y)
        }
    }
}
