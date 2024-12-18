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
@ASTDecodable("tracking")
struct _TrackingModifier<Root: RootRegistry>: TextModifier {
    let tracking: AttributeReference<CoreFoundation.CGFloat>

    @ObservedElement private var element
    @LiveContext<Root> private var context
    
    init(_ tracking: AttributeReference<CoreFoundation.CGFloat>) {
        self.tracking = tracking
    }

    func body(content: Content) -> some View {
        content
            .tracking(tracking.resolve(on: element, in: context))
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        text
            .tracking(tracking.resolve(on: element, in: context))
    }
}
