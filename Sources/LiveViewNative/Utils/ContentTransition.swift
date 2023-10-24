//
//  ContentTransition.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

/// Configuration for the ``ContentTransitionModifier`` modifier.
///
/// In their simplest form, content transitions can be created with an atom. More complex content transitions can have properties.
///
/// ```elixir
/// :interpolate
/// {:numeric_text, [counts_down: true]}
/// ```
///
/// ## Content Transitions
/// Transitions with no required arguments can be represented with an atom.
///
/// ```elixir
/// :interpolate
/// ```
///
/// To pass arguments, use a tuple with a keyword list as the second element.
///
/// ```elixir
/// {:numeric_text, [counts_down: true]}
/// ```
///
/// ### :identity
/// See [`SwiftUI.ContentTransition.identity`](https://developer.apple.com/documentation/swiftui/contenttransition/identity) for more details on this content transition.
///
/// ### :interpolate
/// See [`SwiftUI.ContentTransition.interpolate`](https://developer.apple.com/documentation/swiftui/contenttransition/interpolate) for more details on this content transition.
///
/// ### :opacity
/// See [`SwiftUI.ContentTransition.opacity`](https://developer.apple.com/documentation/swiftui/contenttransition/opacity) for more details on this content transition.
///
/// ### :identity
/// Arguments:
/// * `counts_down` - Whether the numbers the text represents count down. Defaults to `false`.
///
/// ### :symbol_effect
/// Arguments:
/// * `effect` - The ``SymbolEffectContentTransition`` effect to apply. Defaults to `automatic`.
/// * `options` - The ``LiveViewNative/SwiftUI/SymbolEffectOptions`` used to configure the transition.
///
/// ```elixir
/// :symbol_effect
/// {:symbol_effect, :replace}
/// {:symbol_effect, [:replace, :off_up]}
/// {:symbol_effect, [:replace, :off_up], [:repeating, {:speed, 0.2}]}
/// ```
///
/// See [`SwiftUI.ContentTransition.numericText`](https://developer.apple.com/documentation/swiftui/contenttransition/numerictext(countsdown:)) for more details on this content transition.
extension ContentTransition: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(ContentTransitionType.self, forKey: .type) {
        case .identity:
            self = .identity
        case .interpolate:
            self = .interpolate
        case .opacity:
            self = .opacity
        case .numericText:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.NumericText.self, forKey: .properties)
            self = .numericText(countsDown: try properties.decodeIfPresent(Bool.self, forKey: .countsDown) ?? false)
        case .symbolEffect:
            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                #if canImport(Symbols)
                self = try container.decodeIfPresent(SymbolEffectContentTransition.self, forKey: .properties)?.transition ?? .symbolEffect
                #else
                self = .identity
                #endif
            } else {
                self = .identity
            }
        }
    }
    
    enum ContentTransitionType: String, Decodable {
        case identity
        case interpolate
        case opacity
        case numericText = "numeric_text"
        case symbolEffect = "symbol_effect"
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        
        enum NumericText: String, CodingKey {
            case countsDown
        }
        
        enum SymbolEffect: CodingKey {
            case symbolEffect
        }
    }
}

#if canImport(Symbols) && swift(>=5.8)
import Symbols

/// A content transition applied to a system image.
///
/// Possible values:
/// * `automatic`
/// * `replace` - Supports the options `down_up`, `up_up`, `off_up`, `by_layer`, and `whole_symbol`.
///
/// ```elixir
/// :automatic
/// :replace
/// [:replace, :up_up, :by_layer]
/// ```
@_documentation(visibility: public)
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct SymbolEffectContentTransition: Decodable {
    let transition: ContentTransition
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let effect: any (SymbolEffect & ContentTransitionSymbolEffect)
        if var container = try? container.nestedUnkeyedContainer(forKey: .effect) {
            let partialEffect = try container.decode(TransitionSymbolEffectType.self)
            var options = [String]()
            while !container.isAtEnd {
                options.append(try container.decode(String.self))
            }
            effect = partialEffect.effect(options: options)
        } else {
            effect = try container.decode(TransitionSymbolEffectType.self, forKey: .effect).effect(options: [])
        }
        
        self.transition = .symbolEffect(
            effect,
            options: try container.decode(SymbolEffectOptions.self, forKey: .options)
        )
    }
    
    enum CodingKeys: CodingKey {
        case effect
        case options
    }
    
    enum TransitionSymbolEffectType: String, Decodable {
        case automatic
        case replace
        
        func effect(options: [String]) -> any (SymbolEffect & ContentTransitionSymbolEffect) {
            switch self {
            case .automatic:
                return AutomaticSymbolEffect.automatic
            case .replace:
                var result = ReplaceSymbolEffect.replace
                for option in options {
                    switch option {
                    case "down_up": result = result.downUp
                    case "up_up": result = result.upUp
                    case "off_up": result = result.offUp
                    case "by_layer": result = result.byLayer
                    case "whole_symbol": result = result.wholeSymbol
                    default: continue
                    }
                }
                return result
            }
        }
    }
}
#endif
