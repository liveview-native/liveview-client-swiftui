//
//  AnyDisclosureGroupStyle+ParseableModifierValue.swift
//  
//
//  Created by Carson Katri on 6/20/24.
//

#if os(iOS) || os(macOS) || os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.DisclosureGroupStyle`](https://developer.apple.com/documentation/swiftui/DisclosureGroupStyle) for more details.
///
/// Possible values:
/// - `.automatic`
@_documentation(visibility: public)
enum AnyDisclosureGroupStyle: String, CaseIterable, ParseableModifierValue, DisclosureGroupStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    
    func makeBody(configuration: Configuration) -> some View {
        let disclosureGroup = SwiftUI.DisclosureGroup.init(isExpanded: configuration.$isExpanded) {
            configuration.content
        } label: {
            configuration.label
        }

        switch self {
        case .automatic:
            disclosureGroup.disclosureGroupStyle(.automatic)
        }
    }
}
#endif
