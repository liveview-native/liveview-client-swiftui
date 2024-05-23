//
//  Transaction.swift
//
//
//  Created by Carson Katri on 5/9/24.
//

import SwiftUI
import LiveViewNativeCore

/// Context used during a state change.
///
/// Provide an `animation` to customize transitions between different states.
///
/// ```elixir
/// %{ animation: :default }
/// %{ animation: :bouncy }
/// ```
///
/// See ``SwiftUI/Animation`` for more details on available animations.
@_documentation(visibility: public)
extension Transaction: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = .init(animation: try makeJSONDecoder().decode(CodableTransaction.self, from: Data(value.utf8)).animation)
    }
}

private struct CodableTransaction: Decodable {
    let animation: Animation?
}

/// See [`SwiftUI.Animation`](https://developer.apple.com/documentation/swiftui/Animation) for more details.
///
/// Standard Animations:
/// - `:default`
/// - `:bouncy`
/// - `:smooth`
/// - `:snappy`
/// - `:spring`
/// - `:interactiveSpring`
/// - `:interpolatingSpring`
///
/// ## Easing Animations
/// Use `.easeIn`, `.easeOut`, `.easeInOut`, and `.linear` with a duration to use a standard easing function.
///
/// ```elixir
/// %{ easeIn: %{ duration: 3 } }
/// %{ easeIn: %{ duration: 1.5 } }
/// ```
///
/// Use `timingCurve` to build a custom bezier timing curve.
///
/// ```elixir
/// %{ timingCurve: [0.1, 0.75, 0.85, 0.35] }
/// ```
extension Animation: Decodable {
    public init(from decoder: any Decoder) throws {
        if let standard = try? decoder.singleValueContainer().decode(String.self) {
            switch standard {
            case "default":
                self = .default
            case "bouncy":
                self = .bouncy
            case "smooth":
                self = .smooth
            case "snappy":
                self = .snappy
            case "spring":
                self = .spring
            case "interactiveSpring":
                self = .interactiveSpring
            case "interpolatingSpring":
                self = .interpolatingSpring
            case "easeIn":
                self = .easeIn
            case "easeOut":
                self = .easeOut
            case "easeInOut":
                self = .easeInOut
            case "linear":
                self = .linear
            default:
                self = .default
            }
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.easeIn) {
                let options = try container.nestedContainer(keyedBy: CodingKeys.EasingKeys.self, forKey: .easeIn)
                self = .easeIn(duration: try options.decode(Double.self, forKey: .duration))
            } else if container.contains(.easeOut) {
                let options = try container.nestedContainer(keyedBy: CodingKeys.EasingKeys.self, forKey: .easeOut)
                self = .easeOut(duration: try options.decode(Double.self, forKey: .duration))
            } else if container.contains(.easeInOut) {
                let options = try container.nestedContainer(keyedBy: CodingKeys.EasingKeys.self, forKey: .easeInOut)
                self = .easeInOut(duration: try options.decode(Double.self, forKey: .duration))
            } else if container.contains(.linear) {
                let options = try container.nestedContainer(keyedBy: CodingKeys.EasingKeys.self, forKey: .linear)
                self = .linear(duration: try options.decode(Double.self, forKey: .duration))
            } else if container.contains(.timingCurve) {
                var curve = try container.nestedUnkeyedContainer(forKey: .timingCurve)
                self = try .timingCurve(curve.decode(Double.self), curve.decode(Double.self), curve.decode(Double.self), curve.decode(Double.self))
            } else {
                throw DecodingError.typeMismatch(Self.self, .init(codingPath: decoder.codingPath, debugDescription: "Unknown animation value"))
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case easeIn
        case easeOut
        case easeInOut
        case linear
        case timingCurve
        
        enum EasingKeys: String, CodingKey {
            case duration
        }
    }
}
