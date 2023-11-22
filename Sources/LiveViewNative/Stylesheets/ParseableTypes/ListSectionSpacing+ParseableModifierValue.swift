//
//  ListSectionSpacing+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(watchOS)
@available(iOS 17.0, watchOS 10.0, *)
extension ListSectionSpacing: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("default").map({ Self.default })
                ConstantAtomLiteral("compact").map({ Self.compact })
                Custom.parser(in: context).map({ Self.custom($0.spacing) })
            }
        }
    }
    
    @ParseableExpression
    struct Custom {
        static let name = "custom"
        
        let spacing: CGFloat
        
        init(_ spacing: CGFloat) {
            self.spacing = spacing
        }
    }
}
#endif
