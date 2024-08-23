//
//  AnyTableStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(macOS) || os(visionOS)
/// See [`SwiftUI.TableStyle`](https://developer.apple.com/documentation/swiftui/TableStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.inset`
/// - `.bordered`
@_documentation(visibility: public)
enum AnyTableStyle: String, CaseIterable, ParseableModifierValue, TableStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case inset
    #if os(macOS)
    case bordered
    #endif
    
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .automatic:
            AutomaticTableStyle.automatic.makeBody(configuration: configuration)
        case .inset:
            InsetTableStyle.inset.makeBody(configuration: configuration)
        #if os(macOS)
        case .bordered:
            BorderedTableStyle.bordered.makeBody(configuration: configuration)
        #endif
        }
    }
}
#endif
