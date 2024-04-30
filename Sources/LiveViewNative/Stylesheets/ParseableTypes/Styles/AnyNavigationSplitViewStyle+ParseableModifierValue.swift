//
//  AnyNavigationSplitViewStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.NavigationSplitViewStyle`](https://developer.apple.com/documentation/swiftui/NavigationSplitViewStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.balanced`
/// - `.prominentDetail`
@_documentation(visibility: public)
enum AnyNavigationSplitViewStyle: String, CaseIterable, ParseableModifierValue, NavigationSplitViewStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case balanced
    case prominentDetail
    
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            AutomaticNavigationSplitViewStyle().makeBody(configuration: configuration)
        case .balanced:
            BalancedNavigationSplitViewStyle().makeBody(configuration: configuration)
        case .prominentDetail:
            ProminentDetailNavigationSplitViewStyle().makeBody(configuration: configuration)
        }
    }
}
