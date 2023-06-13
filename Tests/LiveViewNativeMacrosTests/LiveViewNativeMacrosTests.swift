//
//  LiveViewNativeMacrosTests.swift
//  
//
//  Created by Carson Katri on 6/6/23.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import LiveViewNativeMacros

let testMacros: [String: Macro.Type] = [
    "Registries": RegistriesMacro.self,
]

final class LiveViewNativeMacrosTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            struct AppRegistry: AggregateRegistry {
                #Registries<
                    AVKitRegistry<Self>,
                    PhotoKitRegistry<Self>,
                    LiveFormsRegistry<Self>
                >
            }
            """,
            expandedSource: """
            struct AppRegistry: AggregateRegistry {
                typealias Registries = _MultiRegistry<
                        AVKitRegistry<Self>, _MultiRegistry<
                        PhotoKitRegistry<Self>,
                        LiveFormsRegistry<Self>>>
            }
            """,
            macros: testMacros
        )
    }
}
