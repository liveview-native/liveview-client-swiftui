//
//  AnyMenuStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
enum AnyMenuStyle: String, CaseIterable, ParseableModifierValue, MenuStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case button
    
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 14, macOS 11, tvOS 17, *) {
            let menu = SwiftUI.Menu(configuration)
            switch self {
            case .automatic:
                menu.menuStyle(.automatic)
            case .button:
                menu.menuStyle(.button)
            }
        }
    }
}
#endif
