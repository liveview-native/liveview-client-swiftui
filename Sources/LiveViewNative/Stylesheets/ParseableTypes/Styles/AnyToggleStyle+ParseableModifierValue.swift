//
//  AnyToggleStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ToggleStyle`](https://developer.apple.com/documentation/swiftui/ToggleStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.button`
/// - `.switch`
/// - `.checkbox`
@_documentation(visibility: public)
enum AnyToggleStyle: String, CaseIterable, ParseableModifierValue, ToggleStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
    case button
    case `switch`
    #endif
    #if os(macOS)
    case checkbox
    #endif
    
    func makeBody(configuration: Configuration) -> some View {
        let toggle = SwiftUI.Toggle(configuration)
        switch self {
        case .automatic:
            toggle.toggleStyle(.automatic)
        #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
        case .button:
            toggle.toggleStyle(.button)
        case .`switch`:
            toggle.toggleStyle(.`switch`)
        #endif
        #if os(macOS)
        case .checkbox:
            toggle.toggleStyle(.checkbox)
        #endif
        }
    }
}
