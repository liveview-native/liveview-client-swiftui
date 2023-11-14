//
//  AnyNavigationSplitViewStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

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
