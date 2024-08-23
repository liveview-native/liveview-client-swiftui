//
//  AnyLabelStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.LabelStyle`](https://developer.apple.com/documentation/swiftui/LabelStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.iconOnly`
/// - `.titleAndIcon`
/// - `.titleOnly`
@_documentation(visibility: public)
enum AnyLabelStyle: String, CaseIterable, ParseableModifierValue, LabelStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case iconOnly
    case titleAndIcon
    case titleOnly
    
    func makeBody(configuration: Configuration) -> some View {
        let label = SwiftUI.Label {
            configuration.title
        } icon: {
            configuration.icon
        }
        switch self {
        case .automatic:
            label.labelStyle(.automatic)
        case .iconOnly:
            label.labelStyle(.iconOnly)
        case .titleAndIcon:
            label.labelStyle(.titleAndIcon)
        case .titleOnly:
            label.labelStyle(.titleOnly)
        }
    }
}
