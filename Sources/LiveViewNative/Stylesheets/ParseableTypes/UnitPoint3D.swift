//
//  File.swift
//  
//
//  Created by Carson.Katri on 4/30/24.
//

#if os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet

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
