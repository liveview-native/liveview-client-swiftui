//
//  ForegroundStyleModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.View/foregroundStyle(_:)`](https://developer.apple.com/documentation/swiftui/view/foregroundStyle(_:)) for more details on this ViewModifier.
///
/// ### foregroundStyle(_:)
/// - `style`: ``SwiftUI/AnyShapeStyle`` (required)
///
/// See [`SwiftUI.View/foregroundStyle(_:)`](https://developer.apple.com/documentation/swiftui/view/foregroundStyle(_:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```elixir
/// # stylesheet
/// "example" do
///   foregroundStyle(AnyShapeStyle)
/// end
/// ```
///
/// ### foregroundStyle(_:_:)
/// - `primary`: ``SwiftUI/AnyShapeStyle`` (required)
/// - `secondary`: ``SwiftUI/AnyShapeStyle`` (required)
///
/// See [`SwiftUI.View/foregroundStyle(_:_:)`](https://developer.apple.com/documentation/swiftui/view/foregroundStyle(_:_:)) for more details on this ViewModifier.
///
/// Example:
/// ```elixir
/// # stylesheet
/// "example" do
///   foregroundStyle(AnyShapeStyle, AnyShapeStyle)
/// end
/// ```
///
/// ### foregroundStyle(_:_:_:)
/// - `primary`: ``SwiftUI/AnyShapeStyle`` (required)
/// - `secondary`: ``SwiftUI/AnyShapeStyle`` (required)
/// - `tertiary`: ``SwiftUI/AnyShapeStyle`` (required)
///
/// See [`SwiftUI.View/foregroundStyle(_:_:)`](https://developer.apple.com/documentation/swiftui/view/foregroundStyle(_:_:_:)) for more details on this ViewModifier.
///
/// Example:
/// ```elixir
/// # stylesheet
/// "example" do
///   foregroundStyle(AnyShapeStyle, AnyShapeStyle, AnyShapeStyle)
/// end
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _ForegroundStyleModifier<R: RootRegistry>: TextModifier {
    static var name: String { "foregroundStyle" }

    enum Value {
        case _0(style: AnyShapeStyle)
        case _1(primary: AnyShapeStyle, secondary: AnyShapeStyle)
        case _2(primary: AnyShapeStyle, secondary: AnyShapeStyle, tertiary: AnyShapeStyle)
    }

    let value: Value
    
    init(_ style: AnyShapeStyle) {
        self.value = ._0(style: style)
    }
    
    init(_ primary: AnyShapeStyle, _ secondary: AnyShapeStyle) {
        self.value = ._1(primary: primary, secondary: secondary)
    }
    
    init(_ primary: AnyShapeStyle, _ secondary: AnyShapeStyle, _ tertiary: AnyShapeStyle) {
        self.value = ._2(primary: primary, secondary: secondary, tertiary: tertiary)
    }

    func body(content: Content) -> some View {
        switch value {
        case let ._0(style):
            content.foregroundStyle(style)
        case let ._1(primary, secondary):
            content.foregroundStyle(primary, secondary)
        case let ._2(primary, secondary, tertiary):
            content.foregroundStyle(primary, secondary, tertiary)
        }
    }
    
    func apply(to text: SwiftUI.Text, on element: ElementNode) -> SwiftUI.Text {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *),
           case let ._0(style) = value
        {
            return text.foregroundStyle(style)
        } else {
            return text
        }
    }
}
