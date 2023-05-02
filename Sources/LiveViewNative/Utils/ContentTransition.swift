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
        }
    }
    
    enum ContentTransitionType: String, Decodable {
        case identity
        case interpolate
        case opacity
        case numericText = "numeric_text"
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        
        enum NumericText: String, CodingKey {
            case countsDown
        }
    }
}
