//
//  AffineTransform3D+ParseableModifierValue.swift
//
//
//  Created by Carson.Katri on 4/30/24.
//

#if os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet

extension AffineTransform3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableAffineTransform3D.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableAffineTransform3D {
        static let name = "AffineTransform3D"
        
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

extension Size3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableSize3D.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableSize3D {
        static let name = "Size3D"
        
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

extension Rotation3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableRotation3D.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableRotation3D {
        static let name = "Rotation3D"
        
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

extension Point3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseablePoint3D.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseablePoint3D {
        static let name = "Point3D"
        
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

extension Vector3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableVector3D.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableVector3D {
        static let name = "Vector3D"
        
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
    
    @ParseableExpression
    struct ParseableAngle2D {
        static let name = "Angle2D"
        
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

extension RotationAxis3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableRotationAxis3D.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableRotationAxis3D {
        static let name = "RotationAxis3D"
        
        let value: RotationAxis3D
        
        init(x: Double, y: Double, z: Double) {
            self.value = .init(x: x, y: y, z: z)
        }
        
        init(_ xyz: Vector3D) {
            self.value = .init(xyz)
        }
    }
}

extension Pose3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseablePose3D.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseablePose3D {
        static let name = "Pose3D"
        
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
    
    @ParseableExpression
    struct XAxis: ParseableModifierValue {
        static let name = "xAxis"
        
        let value: AxisWithFactors
        
        init(yShearFactor: Double, zShearFactor: Double) {
            self.value = .xAxis(yShearFactor: yShearFactor, zShearFactor: zShearFactor)
        }
    }
    
    @ParseableExpression
    struct YAxis: ParseableModifierValue {
        static let name = "yAxis"
        
        let value: AxisWithFactors
        
        init(xShearFactor: Double, zShearFactor: Double) {
            self.value = .yAxis(xShearFactor: xShearFactor, zShearFactor: zShearFactor)
        }
    }
    
    @ParseableExpression
    struct ZAxis: ParseableModifierValue {
        static let name = "zAxis"
        
        let value: AxisWithFactors
        
        init(xShearFactor: Double, yShearFactor: Double) {
            self.value = .zAxis(xShearFactor: xShearFactor, yShearFactor: yShearFactor)
        }
    }
}
#endif
