//
//  LiveViewNativeMacros.swift
//
//
//  Created by Carson Katri on 6/6/23.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct LiveViewNativeMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RegistriesMacro.self,
        LiveViewMacro.self,
        
        LiveElementMacro.self,
        LiveAttributeMacro.self,
        LiveElementIgnoredMacro.self,
        
        AddonMacro.self
    ]
}
