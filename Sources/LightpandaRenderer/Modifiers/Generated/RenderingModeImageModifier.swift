//
//  RenderingModeImageModifier.swift
//  LightpandaRenderer
//
//  Image modifier for renderingMode(_:)
//

import SwiftUI
import SwiftSyntax

/// Image modifier for `renderingMode(_:)`
///
/// Usage:
/// ```html
/// <image name="myIcon" modifiers="renderingMode(.template)">
/// <image name="myIcon" modifiers="renderingMode(.original)">
/// ```
@MainActor
enum RenderingModeImageModifier: RuntimeImageModifier {
    case renderingMode(Image.TemplateRenderingMode?)

    static let baseName = "renderingMode"

    init(syntax: FunctionCallExprSyntax) throws {
        let mode = syntax.arguments.first.flatMap({ Image.TemplateRenderingMode(syntax: $0.expression) })
        self = .renderingMode(mode)
    }

    func imageBody(content: SwiftUI.Image) -> SwiftUI.Image {
        switch self {
        case .renderingMode(let mode):
            return content.renderingMode(mode)
        }
    }
}
