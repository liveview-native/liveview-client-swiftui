//
//  AnyButtonStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/25/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.PrimitiveButtonStyle`](https://developer.apple.com/documentation/swiftui/PrimitiveButtonStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.borderless`
/// - `.plain`
/// - `.bordered`
/// - `.borderedProminent`
@_documentation(visibility: public)
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
            if #available(iOS 13, macOS 10.15, tvOS 17, watchOS 8, *) {
                button.buttonStyle(.borderless)
            } else {
                button
            }
        case .plain:
            button.buttonStyle(.plain)
        case .bordered:
            button.buttonStyle(.bordered)
        case .borderedProminent:
            button.buttonStyle(.borderedProminent)
        }
    }
}

/// Use ``AnyPrimitiveButtonStyle`` instead.
@_documentation(visibility: public)
enum AnyButtonStyle: String, CaseIterable, ParseableModifierValue, ButtonStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case __never
    
    func makeBody(configuration: Configuration) -> some View {
        fatalError()
    }
}
