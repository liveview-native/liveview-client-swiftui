//
//  ShapeBooleanModifiers.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Shape/intersection(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/intersection(_:eoFill:)) for more details on this ViewModifier.
///
/// ### intersection(_:eoFill:)
/// - `other`: ``SwiftUI/AnyShape`` (required)
/// - `eoFill`: ``Swift/Bool``
///
/// See [`SwiftUI.Shape/intersection(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/intersection(_:eoFill:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   intersection(.rect, eoFill: false)
/// end
/// ```
@_documentation(visibility: public)
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

/// See [`SwiftUI.Shape/union(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/union(_:eoFill:)) for more details on this ViewModifier.
///
/// ### union(_:eoFill:)
/// - `other`: ``SwiftUI/AnyShape`` (required)
/// - `eoFill`: ``Swift/Bool``
///
/// See [`SwiftUI.Shape/union(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/union(_:eoFill:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   union(.rect, eoFill: false)
/// end
/// ```
@_documentation(visibility: public)
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

/// See [`SwiftUI.Shape/subtracting(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/subtracting(_:eoFill:)) for more details on this ViewModifier.
///
/// ### subtracting(_:eoFill:)
/// - `other`: ``SwiftUI/AnyShape`` (required)
/// - `eoFill`: ``Swift/Bool``
///
/// See [`SwiftUI.Shape/subtracting(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/subtracting(_:eoFill:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   subtracting(.rect, eoFill: false)
/// end
/// ```
@_documentation(visibility: public)
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

/// See [`SwiftUI.Shape/symmetricDifference(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/symmetricDifference(_:eoFill:)) for more details on this ViewModifier.
///
/// ### symmetricDifference(_:eoFill:)
/// - `other`: ``SwiftUI/AnyShape`` (required)
/// - `eoFill`: ``Swift/Bool``
///
/// See [`SwiftUI.Shape/symmetricDifference(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/symmetricDifference(_:eoFill:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   symmetricDifference(.rect, eoFill: false)
/// end
/// ```
@_documentation(visibility: public)
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

/// See [`SwiftUI.Shape/lineIntersection(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/lineIntersection(_:eoFill:)) for more details on this ViewModifier.
///
/// ### lineIntersection(_:eoFill:)
/// - `other`: ``SwiftUI/AnyShape`` (required)
/// - `eoFill`: ``Swift/Bool``
///
/// See [`SwiftUI.Shape/lineIntersection(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/lineIntersection(_:eoFill:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   lineIntersection(.rect, eoFill: false)
/// end
/// ```
@_documentation(visibility: public)
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

/// See [`SwiftUI.Shape/lineSubtraction(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/lineSubtraction(_:eoFill:)) for more details on this ViewModifier.
///
/// ### lineSubtraction(_:eoFill:)
/// - `other`: ``SwiftUI/AnyShape`` (required)
/// - `eoFill`: ``Swift/Bool``
///
/// See [`SwiftUI.Shape/lineSubtraction(_:eoFill:)`](https://developer.apple.com/documentation/swiftui/shape/lineSubtraction(_:eoFill:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   lineSubtraction(.rect, eoFill: false)
/// end
/// ```
@_documentation(visibility: public)
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
