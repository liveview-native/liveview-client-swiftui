//
//  TrackingModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/tracking(_:)`](https://developer.apple.com/documentation/swiftui/view/tracking(_:)) for more details on this ViewModifier.
///
/// ### tracking(_:)
/// - `tracking`: `attr("...")` or ``CoreFoundation/CGFloat`` (required)
///
/// See [`SwiftUI.View/tracking(_:)`](https://developer.apple.com/documentation/swiftui/view/tracking(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='tracking(attr("tracking"))' tracking={@tracking} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _TrackingModifier<R: RootRegistry>: TextModifier {
    static var name: String { "tracking" }

    let tracking: AttributeReference<CoreFoundation.CGFloat>

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(_ tracking: AttributeReference<CoreFoundation.CGFloat>) {
        self.tracking = tracking
    }

    func body(content: Content) -> some View {
        content
            .tracking(tracking.resolve(on: element, in: context))
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        text
            .tracking(tracking.resolve(on: element))
    }
}
