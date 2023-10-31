//
//  AnyButtonStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/25/23.
//

import SwiftUI
import LiveViewNativeStylesheet

enum AnyPrimitiveButtonStyle: String, CaseIterable, ParseableModifierValue, PrimitiveButtonStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case borderless
    case plain
    case bordered
    case borderedProminent
    
    func makeBody(configuration: Configuration) -> some View {
        let button = SwiftUI.Button(configuration)
        switch self {
        case .automatic:
            button.buttonStyle(.automatic)
        case .borderless:
            button.buttonStyle(.borderless)
        case .plain:
            button.buttonStyle(.plain)
        case .bordered:
            button.buttonStyle(.bordered)
        case .borderedProminent:
            button.buttonStyle(.borderedProminent)
        }
    }
}

enum AnyButtonStyle: String, CaseIterable, ParseableModifierValue, ButtonStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case __never
    
    func makeBody(configuration: Configuration) -> some View {
        fatalError()
    }
}
