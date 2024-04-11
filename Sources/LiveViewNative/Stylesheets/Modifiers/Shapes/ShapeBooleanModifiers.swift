//
//  ShapeBooleanModifiers.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _IntersectionModifier: ShapeModifier {
    static let name = "intersection"

    let other: AnyShape
    let eoFill: Bool
    
    init(_ other: AnyShape, eoFill: Bool = false) {
        self.other = other
        self.eoFill = eoFill
    }

    func apply(to shape: AnyShape, on element: ElementNode) -> some SwiftUI.Shape {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return AnyShape(shape.intersection(other, eoFill: eoFill))
        } else {
            return shape
        }
    }
}

@ParseableExpression
struct _UnionModifier: ShapeModifier {
    static let name = "union"

    let other: AnyShape
    let eoFill: Bool
    
    init(_ other: AnyShape, eoFill: Bool = false) {
        self.other = other
        self.eoFill = eoFill
    }

    func apply(to shape: AnyShape, on element: ElementNode) -> some SwiftUI.Shape {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return AnyShape(shape.union(other, eoFill: eoFill))
        } else {
            return shape
        }
    }
}

@ParseableExpression
struct _SubtractingModifier: ShapeModifier {
    static let name = "subtracting"

    let other: AnyShape
    let eoFill: Bool
    
    init(_ other: AnyShape, eoFill: Bool = false) {
        self.other = other
        self.eoFill = eoFill
    }

    func apply(to shape: AnyShape, on element: ElementNode) -> some SwiftUI.Shape {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return AnyShape(shape.subtracting(other, eoFill: eoFill))
        } else {
            return shape
        }
    }
}

@ParseableExpression
struct _SymmetricDifferenceModifier: ShapeModifier {
    static let name = "symmetricDifference"

    let other: AnyShape
    let eoFill: Bool
    
    init(_ other: AnyShape, eoFill: Bool = false) {
        self.other = other
        self.eoFill = eoFill
    }

    func apply(to shape: AnyShape, on element: ElementNode) -> some SwiftUI.Shape {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return AnyShape(shape.symmetricDifference(other, eoFill: eoFill))
        } else {
            return shape
        }
    }
}

@ParseableExpression
struct _LineIntersectionModifier: ShapeModifier {
    static let name = "lineIntersection"

    let other: AnyShape
    let eoFill: Bool
    
    init(_ other: AnyShape, eoFill: Bool = false) {
        self.other = other
        self.eoFill = eoFill
    }

    func apply(to shape: AnyShape, on element: ElementNode) -> some SwiftUI.Shape {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return AnyShape(shape.lineIntersection(other, eoFill: eoFill))
        } else {
            return shape
        }
    }
}

@ParseableExpression
struct _LineSubtractionModifier: ShapeModifier {
    static let name = "lineSubtraction"

    let other: AnyShape
    let eoFill: Bool
    
    init(_ other: AnyShape, eoFill: Bool = false) {
        self.other = other
        self.eoFill = eoFill
    }

    func apply(to shape: AnyShape, on element: ElementNode) -> some SwiftUI.Shape {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return AnyShape(shape.lineSubtraction(other, eoFill: eoFill))
        } else {
            return shape
        }
    }
}
