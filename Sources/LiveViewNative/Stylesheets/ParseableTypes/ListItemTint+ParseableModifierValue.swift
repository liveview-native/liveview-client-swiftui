//
//  ListItemTint+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension ListItemTint: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                "monochrome".utf8.map({ Self.monochrome })
                Fixed.parser(in: context).map({ Self.fixed($0.tint) })
                Preferred.parser(in: context).map({ Self.preferred($0.tint) })
            }
        }
    }
    
    @ParseableExpression
    struct Fixed {
        static let name = "fixed"
        
        let tint: Color
        
        init(_ tint: Color) {
            self.tint = tint
        }
    }
    
    @ParseableExpression
    struct Preferred {
        static let name = "preferred"
        
        let tint: Color
        
        init(_ tint: Color) {
            self.tint = tint
        }
    }
}
