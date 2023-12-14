//
//  Edge+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension Edge: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "top": .top,
            "bottom": .bottom,
            "leading": .leading,
            "trailing": .trailing,
        ])
    }
}

extension Edge.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Edge.parser(in: context).map({ Self.init($0) })
            Array<Edge>.parser(in: context).map({
                $0.reduce(into: Self()) { $0.insert(.init($1)) }
            })
            ImplicitStaticMember([
                "all": .all,
                "horizontal": .horizontal,
                "vertical": .vertical,
            ])
        }
    }
}

extension EdgeInsets: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableEdgeInsets.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableEdgeInsets {
        static let name = "EdgeInsets"
        
        let value: EdgeInsets
        
        init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
            self.value = .init(top: top, leading: leading, bottom: bottom, trailing: trailing)
        }
        
        init() {
            self.value = .init()
        }
    }
}

extension HorizontalEdge.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "leading": .leading,
                "trailing": .trailing,
                "all": .all,
            ])
            Array<HorizontalEdge>.parser(in: context).map({ Self.init($0.map(Self.init)) })
        }
    }
}

extension VerticalEdge.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "top": top,
                "bottom": bottom,
                "all": all,
            ])
            Array<VerticalEdge>.parser(in: context).map({ Self.init($0.map(Self.init)) })
        }
    }
}
