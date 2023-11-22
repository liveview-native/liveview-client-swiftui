//
//  SearchFieldPlacement+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension SearchFieldPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                ConstantAtomLiteral("toolbar").map({ Self.toolbar })
                ConstantAtomLiteral("sidebar").map({ Self.sidebar })
                ConstantAtomLiteral("navigationBarDrawer").map({ Self.navigationBarDrawer })
                NavigationBarDrawer.parser(in: context).map({ Self.navigationBarDrawer(displayMode: $0.displayMode) })
            }
        }
    }
    
    @ParseableExpression
    struct NavigationBarDrawer {
        static let name = "navigationBarDrawer"
        
        let displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode
        
        init(displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode) {
            self.displayMode = displayMode
        }
    }
}

extension SearchFieldPlacement.NavigationBarDrawerDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "automatic": .automatic,
            "always": .always,
        ])
    }
}
