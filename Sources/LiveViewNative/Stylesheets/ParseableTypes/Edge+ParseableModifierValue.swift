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
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("top").map({ Self.top })
                ConstantAtomLiteral("bottom").map({ Self.bottom })
                ConstantAtomLiteral("leading").map({ Self.leading })
                ConstantAtomLiteral("trailing").map({ Self.trailing })
            }
        }
    }
}

extension Edge.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Edge.parser(in: context).map({ Self.init($0) })
            Array<Edge>.parser(in: context).map({
                $0.reduce(into: Edge.Set()) { $0.insert(.init($1)) }
            })
            ImplicitStaticMember {
                OneOf {
                    ConstantAtomLiteral("all").map({ Self.all })
                    ConstantAtomLiteral("horizontal").map({ Self.horizontal })
                    ConstantAtomLiteral("vertical").map({ Self.vertical })
                }
            }
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
