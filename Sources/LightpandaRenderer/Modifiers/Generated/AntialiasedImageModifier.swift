//
//  AntialiasedImageModifier.swift
//  LightpandaRenderer
//
//  Image modifier for antialiased(_:)
//

import SwiftUI
import SwiftSyntax

/// Image modifier for `antialiased(_:)`
///
/// Usage:
/// ```html
/// <image name="photo" modifiers="antialiased(true)">
/// <image name="pixelArt" modifiers="antialiased(false)">
/// ```
@MainActor
enum AntialiasedImageModifier: RuntimeImageModifier {
    case antialiased(Bool)

    static let baseName = "antialiased"

    init(syntax: FunctionCallExprSyntax) throws {
        let isAntialiased = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .antialiased(isAntialiased)
    }

    func imageBody(content: SwiftUI.Image) -> SwiftUI.Image {
        switch self {
        case .antialiased(let isAntialiased):
            return content.antialiased(isAntialiased)
        }
    }
}
