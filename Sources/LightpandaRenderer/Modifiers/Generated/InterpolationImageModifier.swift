//
//  InterpolationImageModifier.swift
//  LightpandaRenderer
//
//  Image modifier for interpolation(_:)
//

import SwiftUI
import SwiftSyntax

/// Image modifier for `interpolation(_:)`
///
/// Usage:
/// ```html
/// <image name="pixelArt" modifiers="interpolation(.none)">
/// <image name="photo" modifiers="interpolation(.high)">
/// ```
@MainActor
enum InterpolationImageModifier: RuntimeImageModifier {
    case interpolation(Image.Interpolation)

    static let baseName = "interpolation"

    init(syntax: FunctionCallExprSyntax) throws {
        guard let interpolation = syntax.arguments.first.flatMap({ Image.Interpolation(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "InterpolationImageModifier", argument: "interpolation")
        }
        self = .interpolation(interpolation)
    }

    func imageBody(content: SwiftUI.Image) -> SwiftUI.Image {
        switch self {
        case .interpolation(let interpolation):
            return content.interpolation(interpolation)
        }
    }
}
