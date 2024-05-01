//
//  File.swift
//  
//
//  Created by Carson.Katri on 4/30/24.
//

#if os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.UnitPoint3D`](https://developer.apple.com/documentation/swiftui/UnitPoint3D) for more details.
///
/// Possible values:
/// - `.origin`
/// - `.zero`
/// - `.topLeadingBack`
/// - `.topLeading`
/// - `.topLeadingFront`
/// - `.topBack`
/// - `.top`
/// - `.topFront`
/// - `.topTrailingBack`
/// - `.topTrailing`
/// - `.topTrailingFront`
/// - `.leadingBack`
/// - `.leading`
/// - `.leadingFront`
/// - `.back`
/// - `.center`
/// - `.front`
/// - `.trailingBack`
/// - `.trailing`
/// - `.trailingFront`
/// - `.bottomLeadingBack`
/// - `.bottomLeading`
/// - `.bottomLeadingFront`
/// - `.bottomBack`
/// - `.bottom`
/// - `.bottomFront`
/// - `.bottomTrailingBack`
/// - `.bottomTrailing`
/// - `.bottomTrailingFront`
///
/// Provide an `x`, `y`, and `z` value to construct a custom 3D unit point:
///
/// ```swift
/// UnitPoint3D(x: 0, y: 0.5, z: 1)
/// ```
@_documentation(visibility: public)
extension UnitPoint3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ParseableUnitPoint3D.parser(in: context).map({ Self.init(x: $0.x, y: $0.y, z: $0.z) })
            
            ImplicitStaticMember([
                "origin": .origin,
                "zero": .zero,
                
                "topLeadingBack": .topLeadingBack,
                "topLeading": .topLeading,
                "topLeadingFront": .topLeadingFront,
                "topBack": .topBack,
                "top": .top,
                "topFront": .topFront,
                "topTrailingBack": .topTrailingBack,
                "topTrailing": .topTrailing,
                "topTrailingFront": .topTrailingFront,
                
                "leadingBack": .leadingBack,
                "leading": .leading,
                "leadingFront": .leadingFront,
                "back": .back,
                "center": .center,
                "front": .front,
                "trailingBack": .trailingBack,
                "trailing": .trailing,
                "trailingFront": .trailingFront,
                
                "bottomLeadingBack": .bottomLeadingBack,
                "bottomLeading": .bottomLeading,
                "bottomLeadingFront": .bottomLeadingFront,
                "bottomBack": .bottomBack,
                "bottom": .bottom,
                "bottomFront": .bottomFront,
                "bottomTrailingBack": .bottomTrailingBack,
                "bottomTrailing": .bottomTrailing,
                "bottomTrailingFront": .bottomTrailingFront,
            ])
        }
    }
    
    @ParseableExpression
    struct ParseableUnitPoint3D {
        static let name = "UnitPoint3D"
        
        let x: CGFloat
        let y: CGFloat
        let z: CGFloat
        
        init(x: CGFloat, y: CGFloat, z: CGFloat) {
            self.x = x
            self.y = y
            self.z = z
        }
    }
}
#endif
