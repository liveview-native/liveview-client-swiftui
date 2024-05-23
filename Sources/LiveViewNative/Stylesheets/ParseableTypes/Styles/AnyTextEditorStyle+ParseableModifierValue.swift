//
//  AnyTextEditorStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/25/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(macOS) || os(visionOS)
/// See [`SwiftUI.TextEditorStyle`](https://developer.apple.com/documentation/swiftui/TextEditorStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.plain`
/// - `.roundedBorder`
@_documentation(visibility: public)
enum AnyTextEditorStyle: String, CaseIterable, ParseableModifierValue, TextEditorStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case plain
    #if os(visionOS)
    case roundedBorder
    #endif
    
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            if #available(iOS 17.0, macOS 14.0, *) {
                AutomaticTextEditorStyle().makeBody(configuration: configuration)
            }
        case .plain:
            if #available(iOS 17.0, macOS 14.0, *) {
                PlainTextEditorStyle().makeBody(configuration: configuration)
            }
        #if os(visionOS)
        case .roundedBorder:
            RoundedBorderTextEditorStyle().makeBody(configuration: configuration)
        #endif
        }
    }
}
#endif
