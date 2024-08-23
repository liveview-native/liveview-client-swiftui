//
//  ToolbarPlacement+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/9/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ToolbarPlacement`](https://developer.apple.com/documentation/swiftui/ToolbarPlacement) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.accessoryBar(id: String)`
/// - `.bottomBar`
/// - `.bottomOrnament`
/// - `.navigationBar`
/// - `.tabBar`
/// - `.windowToolbar`
@_documentation(visibility: public)
extension ToolbarPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                #if os(macOS)
                AccessoryBar.parser(in: context).map({ Self.accessoryBar(id: $0.id) })
                #endif
                #if !os(tvOS) && !os(macOS)
                if #available(watchOS 10, *) {
                    ConstantAtomLiteral("bottomBar").map({ Self.bottomBar })
                }
                #endif
                #if os(visionOS)
                ConstantAtomLiteral("bottomOrnament").map({ Self.bottomOrnament })
                #endif
                #if !os(macOS)
                ConstantAtomLiteral("navigationBar").map({ Self.navigationBar })
                #endif
                #if !os(watchOS) && !os(macOS)
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
