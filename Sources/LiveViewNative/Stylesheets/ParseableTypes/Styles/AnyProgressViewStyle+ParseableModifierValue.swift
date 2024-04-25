//
//  AnyProgressViewStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ProgressViewStyle`](https://developer.apple.com/documentation/swiftui/ProgressViewStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.circular`
/// - `.linear`
@_documentation(visibility: public)
enum AnyProgressViewStyle: String, CaseIterable, ParseableModifierValue, ProgressViewStyle {
    typealias _ParserType = ImplicitStaticMember<Self, EnumParser<Self>>
    
    case automatic
    case circular
    case linear
    
    func makeBody(configuration: Configuration) -> some View {
        let progressView = SwiftUI.ProgressView(configuration)
        switch self {
        case .automatic:
            progressView.progressViewStyle(.automatic)
        case .circular:
            progressView.progressViewStyle(.circular)
        case .linear:
            progressView.progressViewStyle(.linear)
        }
    }
}
