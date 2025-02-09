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
struct _RotationModifier<Root: RootRegistry>: ShapeModifier {
    static var name: String { "rotation" }

    let angle: AttributeReference<Angle>
    let anchor: AttributeReference<UnitPoint>
    
    init(
        _ angle: AttributeReference<Angle>,
        anchor: AttributeReference<UnitPoint> = .init(.center)
    ) {
        self.angle = angle
        self.anchor = anchor
    }

    @MainActor
    func apply(to shape: AnyShape, on element: ElementNode, in context: LiveContext<Root>) -> some SwiftUI.Shape {
        return shape.rotation(angle.resolve(on: element, in: context), anchor: anchor.resolve(on: element, in: context))
    }
}
