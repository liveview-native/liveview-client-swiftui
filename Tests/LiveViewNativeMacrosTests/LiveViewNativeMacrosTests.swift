//
//  LiveViewNativeMacrosTests.swift
//  
//
//  Created by Carson Katri on 6/6/23.
//

#if os(macOS)
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import LiveViewNativeMacros

let testMacros: [String: Macro.Type] = [
    "Registries": RegistriesMacro.self,
    "LiveView": LiveViewMacro.self
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
    
    func testLiveViewMacro() {
        assertMacroExpansion(
            """
            #LiveView(.localhost, configuration: .init(), addons: [AVKitRegistry<EmptyRegistry>.self])
            """,
            expandedSource: """
            { () -> AnyView in
                enum __macro_local_8RegistryfMu_: AggregateRegistry {
                    typealias Registries = AVKitRegistry<Self>
                }
            
                return AnyView(LiveView(registry: __macro_local_8RegistryfMu_.self, .localhost, configuration: .init()))
            }()
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #LiveView(
                .automatic(development: .localhost(port: 5000), production: .custom(URL(string: "example.com")!)),
                addons: [
                    AVKitRegistry<EmptyRegistry>.self,
                    ChartsRegistry<EmptyRegistry>.self
                ]
            )
            """,
            expandedSource: """
            { () -> AnyView in
                enum __macro_local_8RegistryfMu_: AggregateRegistry {
                    typealias Registries = _MultiRegistry<
                            AVKitRegistry<Self>,
                            ChartsRegistry<Self>>
                }
            
                return AnyView(LiveView(registry: __macro_local_8RegistryfMu_.self,
                .automatic(development: .localhost(port: 5000), production: .custom(URL(string: "example.com")!))))
            }()
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #LiveView(.localhost, configuration: .init(), addons: [AVKitRegistry<_>.self, ChartsRegistry<Self>.self, PhotoKitRegistry<_>.self])
            """,
            expandedSource: """
            { () -> AnyView in
                enum __macro_local_8RegistryfMu_: AggregateRegistry {
                    typealias Registries = _MultiRegistry<AVKitRegistry<Self>, _MultiRegistry<ChartsRegistry<Self>, PhotoKitRegistry<Self>>>
                }
            
                return AnyView(LiveView(registry: __macro_local_8RegistryfMu_.self, .localhost, configuration: .init()))
            }()
            """,
            macros: testMacros
        )
    }
}
#endif
