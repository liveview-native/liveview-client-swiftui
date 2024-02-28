//
//  ForegroundStyleModifier.swift
//
//
//  Created by Carson Katri on 2/21/24.
//

import SwiftUI
import LiveViewNativeStylesheet

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
