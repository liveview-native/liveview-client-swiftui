//
//  AnyButtonStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/25/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.TextFieldStyle`](https://developer.apple.com/documentation/swiftui/TextFieldStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.roundedBorder`
/// - `.plain`
@_documentation(visibility: public)
enum AnyTextFieldStyle: String, CaseIterable, ParseableModifierValue, TextFieldStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    #if os(iOS) || os(macOS)
    case roundedBorder
    #endif
    case plain
    
    func _body(configuration: SwiftUI.TextField<Self._Label>) -> some View {
        switch self {
        case .automatic:
            configuration
                .textFieldStyle(.automatic)
#if os(iOS) || os(macOS)
        case .roundedBorder:
            configuration
                .textFieldStyle(.roundedBorder)
#endif
        case .plain:
            configuration
                .textFieldStyle(.plain)
        }
    }
}
