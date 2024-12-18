//
//  UnitPoint+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/19/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.UnitPoint`](https://developer.apple.com/documentation/swiftui/UnitPoint) for more details.
///
/// Standard Unit Points:
/// - `.zero`
/// - `.center`
/// - `.leading`
/// - `.trailing`
/// - `.top`
/// - `.bottom`
/// - `.topLeading`
/// - `.topTrailing`
/// - `.bottomLeading`
/// - `.bottomTrailing`
///
/// Use an `x` and `y` value to construct a custom unit point.
///
/// ```swift
/// UnitPoint(x: 0.5, y: 0.5)
/// UnitPoint(x: 0, y: 0)
/// ```
@_documentation(visibility: public)
extension UnitPoint: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ParseableUnitPoint.parser(in: context).map({ Self.init(x: $0.x, y: $0.y) })
            
            ImplicitStaticMember([
                "zero": Self.zero,
                "center": Self.center,
                "leading": Self.leading,
                "trailing": Self.trailing,
                "top": Self.top,
                "bottom": Self.bottom,
                "topLeading": Self.topLeading,
                "topTrailing": Self.topTrailing,
                "bottomLeading": Self.bottomLeading,
                "bottomTrailing": Self.bottomTrailing,
            ])
        }
    }
    
    @ASTDecodable("UnitPoint")
    struct ParseableUnitPoint {
        let x: CGFloat
        let y: CGFloat
        
        init(x: CGFloat, y: CGFloat) {
            self.x = x
            self.y = y
        }
    }
}
