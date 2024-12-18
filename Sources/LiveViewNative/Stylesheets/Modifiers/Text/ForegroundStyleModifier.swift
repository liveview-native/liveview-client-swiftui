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
@ASTDecodable("foregroundStyle")
struct _ForegroundStyleModifier<Root: RootRegistry>: TextModifier {
    enum Value {
        case _0(style: AnyShapeStyle.Resolvable)
        case _1(primary: AnyShapeStyle.Resolvable, secondary: AnyShapeStyle.Resolvable)
        case _2(primary: AnyShapeStyle.Resolvable, secondary: AnyShapeStyle.Resolvable, tertiary: AnyShapeStyle.Resolvable)
    }

    let value: Value
    
    @ObservedElement private var element
    @LiveContext<Root> private var context
    
    init(_ style: AnyShapeStyle.Resolvable) {
        self.value = ._0(style: style)
    }
    
    init(_ primary: AnyShapeStyle.Resolvable, _ secondary: AnyShapeStyle.Resolvable) {
        self.value = ._1(primary: primary, secondary: secondary)
    }
    
    init(_ primary: AnyShapeStyle.Resolvable, _ secondary: AnyShapeStyle.Resolvable, _ tertiary: AnyShapeStyle.Resolvable) {
        self.value = ._2(primary: primary, secondary: secondary, tertiary: tertiary)
    }

    func body(content: Content) -> some View {
        switch value {
        case let ._0(style):
            content.foregroundStyle(style.resolve(on: element, in: context))
        case let ._1(primary, secondary):
            content.foregroundStyle(primary.resolve(on: element, in: context), secondary.resolve(on: element, in: context))
        case let ._2(primary, secondary, tertiary):
            content.foregroundStyle(primary.resolve(on: element, in: context), secondary.resolve(on: element, in: context), tertiary.resolve(on: element, in: context))
        }
    }
    
    func apply<R: RootRegistry>(to text: SwiftUI.Text, on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *),
           case let ._0(style) = value
        {
            return text.foregroundStyle(style.resolve(on: element, in: context))
        } else {
            return text
        }
    }
}
