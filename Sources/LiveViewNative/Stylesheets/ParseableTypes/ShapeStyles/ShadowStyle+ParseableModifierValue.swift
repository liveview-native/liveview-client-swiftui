//
//  ShadowStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 1/18/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ShadowStyle`](https://developer.apple.com/documentation/swiftui/ShadowStyle) for more details.
///
/// A `drop` or `inner` shadow applied to a ``SwiftUI/AnyShapeStyle``.
///
/// ### drop
/// Parameters:
/// - `color`: ``SwiftUI/Color``
/// - `radius`: ``CoreFoundation/CGFloat`` (required)
/// - `x`: ``CoreFoundation/CGFloat``
/// - `y`: ``CoreFoundation/CGFloat``
///
/// Example:
/// ```swift
/// .drop(radius: 10)
/// .drop(color: .red, radius: 8, x: 10, y: -8)
/// ```
///
/// ### inner
/// Parameters:
/// - `color`: ``SwiftUI/Color``
/// - `radius`: ``CoreFoundation/CGFloat`` (required)
/// - `x`: ``CoreFoundation/CGFloat``
/// - `y`: ``CoreFoundation/CGFloat``
///
/// Example:
/// ```swift
/// .inner(radius: 10)
/// .inner(color: .red, radius: 8, x: 10, y: -8)
/// ```
@_documentation(visibility: public)
extension ShadowStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                _drop.parser(in: context).map(\.value)
                _inner.parser(in: context).map(\.value)
            }
        }
    }
    
    @ParseableExpression
    struct _drop {
        static let name = "drop"
        
        let value: ShadowStyle
        
        init(color: Color = .init(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
            self.value = .drop(color: color, radius: radius, x: x, y: y)
        }
    }
    
    @ParseableExpression
    struct _inner {
        static let name = "inner"
        
        let value: ShadowStyle
        
        init(color: Color = .init(.sRGBLinear, white: 0, opacity: 0.55), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
            self.value = .inner(color: color, radius: radius, x: x, y: y)
        }
    }
}
