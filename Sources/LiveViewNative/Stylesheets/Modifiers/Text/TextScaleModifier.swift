//
//  TextScaleModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/textScale(_:isEnabled:)`](https://developer.apple.com/documentation/swiftui/view/textScale(_:isEnabled:)) for more details on this ViewModifier.
///
/// ### textScale(_:isEnabled:)
/// - `scale`: ``SwiftUI/Text/Scale``
/// - `isEnabled`: `attr("...")` or ``Swift/Bool``
///
/// See [`SwiftUI.View/textScale(_:isEnabled:)`](https://developer.apple.com/documentation/swiftui/view/textScale(_:isEnabled:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='textScale(.default, isEnabled: attr("isEnabled"))' isEnabled={@isEnabled} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _TextScaleModifier<R: RootRegistry>: TextModifier {
    static var name: String { "textScale" }

    let scale: Any
    let isEnabled: AttributeReference<Bool>

    @ObservedElement private var element
    @LiveContext<R> private var context

    @available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, visionOS 1, *)
    init(_ scale: SwiftUI.Text.Scale, isEnabled: AttributeReference<Bool> = .init(storage: .constant(true))) {
        self.scale = scale
        self.isEnabled = isEnabled
    }

    func body(content: Content) -> some View {
        if #available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, visionOS 1, *) {
            content
                .textScale(scale as! SwiftUI.Text.Scale, isEnabled: isEnabled.resolve(on: element, in: context))
        } else {
            content
        }
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        if #available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, visionOS 1, *) {
            return text
                .textScale(scale as! SwiftUI.Text.Scale, isEnabled: isEnabled.resolve(on: element))
        } else {
            return text
        }
    }
}
