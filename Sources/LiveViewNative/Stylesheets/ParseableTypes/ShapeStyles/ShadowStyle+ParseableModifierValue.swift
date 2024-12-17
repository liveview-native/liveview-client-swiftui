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
@MainActor
enum _ShadowStyle: ParseableModifierValue {
    case drop(_drop)
    case inner(_inner)
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                _drop.parser(in: context).map(Self.drop)
                _inner.parser(in: context).map(Self.inner)
            }
        }
    }
    
    func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> ShadowStyle {
        switch self {
        case .drop(let drop):
            .drop(
                color: drop.color.resolve(on: element, in: context),
                radius: drop.radius.resolve(on: element, in: context),
                x: drop.x.resolve(on: element, in: context),
                y: drop.y.resolve(on: element, in: context)
            )
        case .inner(let inner):
            .inner(
                color: inner.color.resolve(on: element, in: context),
                radius: inner.radius.resolve(on: element, in: context),
                x: inner.x.resolve(on: element, in: context),
                y: inner.y.resolve(on: element, in: context)
            )
        }
    }
    
    @MainActor
    @ParseableExpression
    struct _drop {
        static let name = "drop"
        
        let color: Color.Resolvable
        let radius: AttributeReference<CGFloat>
        let x: AttributeReference<CGFloat>
        let y: AttributeReference<CGFloat>
        
        init(
            color: Color.Resolvable = .init(.init(.sRGBLinear, white: 0, opacity: 0.33)),
            radius: AttributeReference<CGFloat>,
            x: AttributeReference<CGFloat> = .init(0),
            y: AttributeReference<CGFloat> = .init(0)
        ) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }
    
    @MainActor
    @ParseableExpression
    struct _inner {
        static let name = "inner"
        
        let color: Color.Resolvable
        let radius: AttributeReference<CGFloat>
        let x: AttributeReference<CGFloat>
        let y: AttributeReference<CGFloat>
        
        init(
            color: Color.Resolvable = .init(.init(.sRGBLinear, white: 0, opacity: 0.55)),
            radius: AttributeReference<CGFloat>,
            x: AttributeReference<CGFloat> = .init(0),
            y: AttributeReference<CGFloat> = .init(0)
        ) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }
}
