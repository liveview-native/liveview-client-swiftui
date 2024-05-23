//
//  RotationModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Shape/rotation(_:anchor:)`](https://developer.apple.com/documentation/swiftui/shape/rotation(_:anchor:)) for more details on this ViewModifier.
///
/// ### rotation(_:anchor:)
/// - `angle`: ``SwiftUI/Angle`` (required)
/// - `anchor`: ``SwiftUI/UnitPoint``
///
/// See [`SwiftUI.Shape/rotation(_:anchor:)`](https://developer.apple.com/documentation/swiftui/shape/rotation(_:anchor:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   rotation(.zero, style: .center)
/// end
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _RotationModifier: ShapeModifier {
    static let name = "rotation"

    let angle: Angle
    let anchor: UnitPoint
    
    init(
        _ angle: Angle,
        anchor: UnitPoint = .center
    ) {
        self.angle = angle
        self.anchor = anchor
    }

    func apply(to shape: AnyShape, on element: ElementNode) -> some SwiftUI.Shape {
        return shape.rotation(angle, anchor: anchor)
    }
}
