//
//  AnyLabeledContentStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

enum AnyLabeledContentStyle: String, CaseIterable, ParseableModifierValue, LabeledContentStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    
    func makeBody(configuration: Configuration) -> some View {
        let labeledContent = SwiftUI.LabeledContent {
            configuration.content
        } label: {
            configuration.label
        }
        switch self {
        case .automatic:
            labeledContent.labelStyle(.automatic)
        }
    }
}
