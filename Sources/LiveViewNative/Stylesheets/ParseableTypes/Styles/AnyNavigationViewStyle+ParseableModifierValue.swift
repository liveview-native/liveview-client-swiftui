//
//  AnyNavigationViewStyle+ParseableModifierValue.swift
//  
//
//  Created by Carson Katri on 6/20/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.NavigationViewStyle`](https://developer.apple.com/documentation/swiftui/NavigationViewStyle) for more details.
///
/// - Note: This type is deprecated and should no longer be used.
@_documentation(visibility: public)
enum AnyNavigationViewStyle: String, CaseIterable, ParseableModifierValue, NavigationViewStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case __never
    
    @ViewBuilder
    func _body(configuration: _NavigationViewStyleConfiguration) -> some View {
        fatalError("This type is deprecated and should no longer be used.")
    }
}
