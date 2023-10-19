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

#warning("fixme: array of edges fails to compile")
extension Edge.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Edge.parser(in: context).map({ Self.init($0) })
//            Array<Edge>.parser().map({ Self.init($0) })
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
