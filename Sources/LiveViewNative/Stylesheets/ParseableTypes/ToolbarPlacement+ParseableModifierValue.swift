//
//  ToolbarPlacement+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/9/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension ToolbarPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                #if os(macOS)
                AccessoryBar.parser(in: context).map({ Self.accessoryBar(id: $0.id) })
                #endif
                #if !os(tvOS)
                ConstantAtomLiteral("bottomBar").map({ Self.bottomBar })
                #endif
                #if os(xrOS)
                ConstantAtomLiteral("bottomOrnament").map({ Self.bottomOrnament })
                #endif
                ConstantAtomLiteral("navigationBar").map({ Self.navigationBar })
                #if !os(watchOS)
                ConstantAtomLiteral("tabBar").map({ Self.tabBar })
                #endif
                #if os(macOS)
                ConstantAtomLiteral("windowToolbar").map({ Self.windowToolbar })
                #endif
            }
        }
    }
    
    @ParseableExpression
    struct AccessoryBar {
        static let name = "accessoryBar"
        
        let id: String
        
        init(id: String) {
            self.id = id
        }
    }
}
