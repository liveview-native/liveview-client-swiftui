//
//  AnyGroupBoxStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(macOS) || os(visionOS)
/// See [`SwiftUI.GroupBoxStyle`](https://developer.apple.com/documentation/swiftui/GroupBoxStyle) for more details.
///
/// Possible values:
/// - `.automatic`
@_documentation(visibility: public)
enum AnyGroupBoxStyle: String, CaseIterable, ParseableModifierValue, GroupBoxStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    
    func makeBody(configuration: Configuration) -> some View {
        let groupBox = SwiftUI.GroupBox(configuration)
        switch self {
        case .automatic:
            groupBox.groupBoxStyle(.automatic)
        }
    }
}
#endif
