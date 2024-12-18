//
//  SearchFieldPlacement+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.SearchFieldPlacement`](https://developer.apple.com/documentation/swiftui/SearchFieldPlacement) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.toolbar`
/// - `.sidebar`
/// - `.navigationBarDrawer`
/// - `.navigationBarDrawer(NavigationBarDrawerDisplayMode)` with a ``SwiftUI/SearchFieldPlacement/NavigationBarDrawerDisplayMode``
@_documentation(visibility: public)
extension SearchFieldPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
                ConstantAtomLiteral("toolbar").map({ Self.toolbar })
                #endif
                #if os(iOS) || os(macOS) || os(visionOS)
                ConstantAtomLiteral("sidebar").map({ Self.sidebar })
                #endif
                #if os(iOS) || os(visionOS)
                ConstantAtomLiteral("navigationBarDrawer").map({ Self.navigationBarDrawer })
                NavigationBarDrawer.parser(in: context).map({ Self.navigationBarDrawer(displayMode: $0.displayMode) })
                #endif
            }
        }
    }
    
    #if os(iOS) || os(visionOS)
    @ASTDecodable("navigationBarDrawer")
    struct NavigationBarDrawer {
        let displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode
        
        init(displayMode: SearchFieldPlacement.NavigationBarDrawerDisplayMode) {
            self.displayMode = displayMode
        }
    }
    #endif
}

#if os(iOS) || os(visionOS)
/// See [`SwiftUI.SearchFieldPlacement.NavigationBarDrawerDisplayMode`](https://developer.apple.com/documentation/swiftui/SearchFieldPlacement/NavigationBarDrawerDisplayMode) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.always`
@_documentation(visibility: public)
extension SearchFieldPlacement.NavigationBarDrawerDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "automatic": .automatic,
            "always": .always,
        ])
    }
}
#endif
