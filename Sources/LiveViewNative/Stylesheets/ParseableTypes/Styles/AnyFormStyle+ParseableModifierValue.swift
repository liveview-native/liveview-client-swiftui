//
//  AnyFormStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.FormStyle`](https://developer.apple.com/documentation/swiftui/FormStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.columns`
/// - `.grouped`
@_documentation(visibility: public)
enum AnyFormStyle: String, CaseIterable, ParseableModifierValue, FormStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case columns
    case grouped
    
    func makeBody(configuration: Configuration) -> some View {
        let form = SwiftUI.Form {
            configuration.content
        }
        switch self {
        case .automatic:
            form.formStyle(.automatic)
        case .columns:
            form.formStyle(.columns)
        case .grouped:
            form.formStyle(.grouped)
        }
    }
}
