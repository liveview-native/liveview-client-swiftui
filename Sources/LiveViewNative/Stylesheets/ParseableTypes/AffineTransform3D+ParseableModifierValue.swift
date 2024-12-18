//
//  AffineTransform3D+ParseableModifierValue.swift
//
//
//  Created by Carson.Katri on 4/30/24.
//

#if os(visionOS)
import SwiftUI
import Spatial
import LiveViewNativeStylesheet

/// See [`Spatial.AffineTransform3D`](https://developer.apple.com/documentation/spatial/AffineTransform3D) for more details.
///
/// Use ``Spatial/Size3D``, ``Spatial/Rotation3D``, ``Spatial/Vector3D``, ``Spatial/Pose3D``, and ``Spatial/AxisWithFactors`` to build a transformation matrix.
///
/// ```swift
/// AffineTransform3D()
/// AffineTransform3D(scale: Size3D(width: 5, height: 1, depth: 2))
/// AffineTransform3D(rotation: .degrees(45), translation: Vector3D(x: 10, z: 5))
/// AffineTransform3D(pose: Pose3D(forward: Vector3D(x: 1))
/// AffineTransform3D(shear: .xAxis(yShearFactor: 1, zShearFactor: 1))
/// ```
@_documentation(visibility: public)
extension AffineTransform3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableAffineTransform3D.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("AffineTransform3D")
    struct ParseableAffineTransform3D {
        let value: AffineTransform3D
        
        init() {
            self.value = .init()
        }
        
        init(
            scale: Size3D = Size3D(width: 1.0, height: 1, depth: 1),
            rotation: Rotation3D = .identity,
            translation: Vector3D = .zero
        ) {
            self.value = .init(
                scale: scale,
                rotation: rotation,
                translation: translation
            )
        }
        
        init(scale: Size3D) {
            self.value = .init(scale: scale)
        }
        
        init(rotation: Rotation3D) {
            self.value = .init(rotation: rotation)
        }
        
        init(translation: Vector3D) {
            self.value = .init(translation: translation)
        }
        
        init(pose: Pose3D) {
            self.value = .init(pose: pose)
        }
        
        init(shear: AxisWithFactors) {
            self.value = .init(shear: shear)
        }
    }
}

/// See [`Spatial.Size3D`](https://developer.apple.com/documentation/spatial/Size3D) for more details.
///
/// Parameters:
/// - `width`: ``Swift/Double``
/// - `height`: ``Swift/Double``
/// - `depth`: ``Swift/Double``
///
/// Example:
///
/// ```swift
/// Size3D()
/// Size3D(width: 10, depth: 5)
/// Size3D(width: 1, height: 2, depth: 3)
/// ```
@_documentation(visibility: public)
extension Size3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableSize3D.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("Size3D")
    struct ParseableSize3D {
        let value: Size3D
        
        init(
            width: Double = 0,
            height: Double = 0,
            depth: Double = 0
        ) {
            self.value = .init(
                width: width,
                height: height,
                depth: depth
            )
        }
    }
}

/// See [`Spatial.Rotation3D`](https://developer.apple.com/documentation/spatial/Rotation3D) for more details.
///
/// Use ``Spatial/Angle2D`` and ``Spatial/RotationAxis3D`` to construct a 3D rotation from an angle and axis.
///
/// ```swift
/// Rotation3D(angle: .degrees(45), axis: RotationAxis3D(x: 1, y: 0, z: 0))
/// ```
///
/// Use a ``Spatial/Point3D`` `position` and `target`, and ``Spatial/Vector3D`` `up` to construct a look rotation.
///
/// ```swift
/// Rotation3D(position: Point3D(), target: Point3D(x: 5), up: Vector3D(z: 1))
/// ```
///
/// Use a ``Spatial/Vector3D`` `forward` and `up` to construct a rotation.
///
/// ```swift
/// Rotation3D(forward: Vector3D(x: 1), up: Vector3D(z: 1))
/// ```
@_documentation(visibility: public)
extension Rotation3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableRotation3D.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("Rotation3D")
    struct ParseableRotation3D {
        let value: Rotation3D
        
        init(angle: Angle2D, axis: RotationAxis3D) {
            self.value = .init(angle: angle, axis: axis)
        }
        
        init(position: Point3D, target: Point3D, up: Vector3D) {
            self.value = .init(position: position, target: target, up: up)
        }
        
        init(forward: Vector3D, up: Vector3D) {
            self.value = .init(forward: forward, up: up)
        }
    }
}

/// See [`Spatial.Point3D`](https://developer.apple.com/documentation/spatial/Point3D) for more details.
///
/// Provide an `x`, `y`, and `z` double to construct a point.
///
/// ```swift
/// Point3D()
/// Point3D(y: 1)
/// Point3D(x: 1, y: 2, z: 3)
/// ```
///
/// You can also convert a ``Spatial/Vector3D`` or ``Spatial/Size3D`` into a point.
///
/// ```swift
/// Point3D(Vector3D(z: 1))
/// Point3D(Size3D(x: 2, y: 2, z: 2))
/// ```
@_documentation(visibility: public)
extension Point3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseablePoint3D.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("Point3D")
    struct ParseablePoint3D {
        let value: Point3D
        
        init() {
            self.value = .init()
        }
        
        init(
            x: Double = 0,
            y: Double = 0,
            z: Double = 0
        ) {
            self.value = .init(x: x, y: y, z: z)
        }
        
        init(_ xyz: Vector3D) {
            self.value = .init(xyz)
        }
        
        init(_ size: Size3D) {
            self.value = .init(size)
        }
    }
}

/// See [`Spatial.Vector3D`](https://developer.apple.com/documentation/spatial/Vector3D) for more details.
///
/// Provide an `x`, `y`, and `z` double to construct a vector.
///
/// ```swift
/// Vector3D()
/// Vector3D(y: 1)
/// Vector3D(x: 1, y: 2, z: 3)
/// ```
///
/// You can also convert a ``Spatial/RotationAxis3D``, ``Spatial/Point3D`` or ``Spatial/Size3D`` into a vector.
///
/// ```swift
/// Vector3D(RotationAxis3D(x: 1, y: 0, z: 1))
/// Vector3D(Point3D(z: 1))
/// Vector3D(Size3D(x: 2, y: 2, z: 2))
/// ```
@_documentation(visibility: public)
extension Vector3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableVector3D.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("Vector3D")
    struct ParseableVector3D {
        let value: Vector3D
        
        init() {
            self.value = .init()
        }
        
        init(
            x: Double = 0,
            y: Double = 0,
            z: Double = 0
        ) {
            self.value = .init(x: x, y: y, z: z)
        }
        
        init(_ axis: RotationAxis3D) {
            self.value = .init(axis)
        }
        
        init(_ point: Point3D) {
            self.value = .init(point)
        }
        
        init(_ size: Size3D) {
            self.value = .init(size)
        }
    }
}

/// See [`Spatial.Angle2D`](https://developer.apple.com/documentation/spatial/Angle2D) for more details.
///
/// Provide an angle in `radians` or `degrees` to construct a angle.
///
/// ```swift
/// Angle2D(radians: 3.14)
/// Angle2D(degrees: 180)
/// .radians(3.14)
/// .degrees(180)
/// ```
///
/// You can also convert a ``SwiftUI/Angle`` into a angle.
///
/// ```swift
/// Angle2D(.radians(3.14))
/// Angle2D(.degrees(180))
/// ```
@_documentation(visibility: public)
extension Angle2D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ParseableAngle2D.parser(in: context).map(\.value)
            ImplicitStaticMember {
                OneOf {
                    SwiftUI.Angle.Radians.parser(in: context).map({ Self.radians($0.radians) })
                    SwiftUI.Angle.Degrees.parser(in: context).map({ Self.degrees($0.degrees) })
                }
            }
        }
    }
    
    @ASTDecodable("Angle2D")
    struct ParseableAngle2D {
        let value: Angle2D
        
        init() {
            self.value = .init()
        }
        
        init(radians: Double) {
            self.value = .init(radians: radians)
        }
        
        init(degrees: Double) {
            self.value = .init(degrees: degrees)
        }
        
        init(_ angle: Angle) {
            self.value = .init(angle)
        }
    }
}

/// See [`Spatial.RotationAxis3D`](https://developer.apple.com/documentation/spatial/RotationAxis3D) for more details.
///
/// Provide an `x`, `y`, and `z` value to specify the axes.
///
/// ```swift
/// RotationAxis3D(x: 1, y: 0, z: 0)
/// ```
///
/// You can also convert a ``SwiftUI/Vector3D`` into a rotation axis.
///
/// ```swift
/// RotationAxis3D(Vector3D(z: 1))
/// ```
@_documentation(visibility: public)
extension RotationAxis3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableRotationAxis3D.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("RotationAxis3D")
    struct ParseableRotationAxis3D {
        let value: RotationAxis3D
        
        init(x: Double, y: Double, z: Double) {
            self.value = .init(x: x, y: y, z: z)
        }
        
        init(_ xyz: Vector3D) {
            self.value = .init(xyz)
        }
    }
}

/// See [`Spatial.Pose3D`](https://developer.apple.com/documentation/spatial/Pose3D) for more details.
///
/// Provide an ``Spatial/Vector3D`` `forward` and `up` to construct a pose.
///
/// ```swift
/// Pose3D(forward: Vector3D(x: 1), up: Vector3D(z: 1))
/// ```
///
/// Provide an ``Spatial/Point3D`` `position` and ``Spatial/Rotation3D`` `rotation` to construct a pose.
///
/// ```swift
/// Pose3D(position: Point3D(), up: Rotation3D(angle: .radians(3.14), axis: RotationAxis3D(x: 1, y: 0, z: 0)))
/// ```
///
/// Provide an ``Spatial/Point3D`` `position` and `target`, and a ``Spatial/Vector3D`` `up` to construct a pose.
///
/// ```swift
/// Pose3D(position: Point3D(), target: Point3D(x: 1))
/// Pose3D(position: Point3D(y: 1), target: Point3D(z: 1), up: Vector3D(z: 1))
/// ```
@_documentation(visibility: public)
extension Pose3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseablePose3D.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("Pose3D")
    struct ParseablePose3D {
        let value: Pose3D
        
        init() {
            self.value = .init()
        }
        
        init(
            forward: Vector3D,
            up: Vector3D = Vector3D(x: 0, y: 1, z: 0)
        ) {
            self.value = .init(forward: forward, up: up)
        }
        
        init(
            position: Point3D,
            rotation: Rotation3D
        ) {
            self.value = .init(position: position, rotation: rotation)
        }
        
        init(
            position: Point3D = .zero,
            target: Point3D,
            up: Vector3D = Vector3D(x: 0, y: 1, z: 0)
        ) {
            self.value = .init(position: position, target: target, up: up)
        }
    }
}

/// See [`Spatial.AxisWithFactors`](https://developer.apple.com/documentation/spatial/AxisWithFactors) for more details.
///
/// Create an `x`, `y`, or `z` axis with shear factors
///
/// ```swift
/// .xAxis(yShearFactor: 1, zShearFactor: 0.5)
/// .yAxis(xShearFactor: 0, zShearFactor: 1)
/// .zAxis(xShearFactor: 2, yShearFactor: 0.5)
/// ```
@_documentation(visibility: public)
extension AxisWithFactors: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                XAxis.parser(in: context).map(\.value)
                YAxis.parser(in: context).map(\.value)
                ZAxis.parser(in: context).map(\.value)
            }
        }
    }
    
    @ASTDecodable("xAxis")
    struct XAxis: ParseableModifierValue {
        let value: AxisWithFactors
        
        init(yShearFactor: Double, zShearFactor: Double) {
            self.value = .xAxis(yShearFactor: yShearFactor, zShearFactor: zShearFactor)
        }
    }
    
    @ASTDecodable("yAxis")
    struct YAxis: ParseableModifierValue {
        let value: AxisWithFactors
        
        init(xShearFactor: Double, zShearFactor: Double) {
            self.value = .yAxis(xShearFactor: xShearFactor, zShearFactor: zShearFactor)
        }
    }
    
    @ASTDecodable("zAxis")
    struct ZAxis: ParseableModifierValue {
        let value: AxisWithFactors
        
        init(xShearFactor: Double, yShearFactor: Double) {
            self.value = .zAxis(xShearFactor: xShearFactor, yShearFactor: yShearFactor)
        }
    }
}
#endif
