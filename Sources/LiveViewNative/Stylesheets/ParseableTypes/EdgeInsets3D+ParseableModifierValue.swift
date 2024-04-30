//
//  EdgeInsets3D+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 4/30/24.
//

#if os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet

extension EdgeInsets3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableEdgeInsets3D.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableEdgeInsets3D {
        static let name = "EdgeInsets"
        
        let value: EdgeInsets3D
        
        init(
            horizontal: CGFloat = 0,
            vertical: CGFloat = 0,
            depth: CGFloat = 0
        ) {
            self.value = .init(
                horizontal: horizontal,
                vertical: vertical,
                depth: depth
            )
        }
        
        init(
            top: CGFloat = 0,
            leading: CGFloat = 0,
            bottom: CGFloat = 0,
            trailing: CGFloat = 0,
            front: CGFloat = 0,
            back: CGFloat = 0
        ) {
            self.value = .init(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing,
                front: front,
                back: back
            )
        }
    }
}

extension Edge3D.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Edge3D.parser(in: context).map({ Self.init($0) })
            Array<Edge3D>.parser(in: context).map({
                $0.reduce(into: Self()) { $0.insert(.init($1)) }
            })
            ImplicitStaticMember([
                "all": .all,
                "horizontal": .horizontal,
                "vertical": .vertical,
                "depth": .depth,
            ])
        }
    }
}
#endif
