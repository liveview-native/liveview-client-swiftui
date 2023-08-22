//
//  AnyTransition.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

/// Configuration for the ``TransitionModifier`` modifier.
///
/// In their simplest form, transitions can be created with an atom. More complex transitions can have properties.
///
/// ```elixir
/// :opacity
/// {:move, [edge: :bottom]} # move in/out from the bottom edge
/// [:scale, :opacity] # multiple transitions combined
/// {:asymmetric, [insertion: :scale, removal: :opacity]} # different transition for insert/remove
/// ```
///
/// ## Transitions
/// Transitions with no required arguments can be represented with an atom.
///
/// ```elixir
/// :opacity
/// ```
///
/// To pass arguments, use a tuple with a keyword list as the second element.
///
/// ```elixir
/// {:move, [edge: :bottom]}
/// ```
///
/// Multiple animations can be combined by using a list.
///
/// ```elixir
/// [:scale, :opacity] # scale up/down while fading in/out
/// ```
///
/// A different animation can be applied to a transition by using a tuple where the first element is the transition, and the second is an animation.
///
/// ```elixir
/// {:scale, :spring}
/// ```
///
/// See ``LiveViewNative/SwiftUI/Animation`` for more details on creating animations.
///
/// ### :identity
/// See [`SwiftUI.AnyTransition.default`](https://developer.apple.com/documentation/swiftui/anytransition/identity) for more details on this transition.
///
/// ### :move
/// Arguments:
/// * `edge` (required) - The side to move in/out from. See ``LiveViewNative/SwiftUI/Edge`` for possible values.
///
/// See [`SwiftUI.AnyTransition.move`](https://developer.apple.com/documentation/swiftui/anytransition/move(edge:)) for more details on this transition.
///
/// ### :offset
/// Arguments:
/// * `x` (required) - The horizontal offset
/// * `y` (required) - The vertical offset
///
/// See [`SwiftUI.AnyTransition.offset`](https://developer.apple.com/documentation/swiftui/anytransition/offset(_:)) for more details on this transition.
///
/// ### :opacity
/// See [`SwiftUI.AnyTransition.opacity`](https://developer.apple.com/documentation/swiftui/anytransition/opacity) for more details on this transition.
///
/// ### :scale
/// Arguments:
/// * `scale` - The scale amount in the range `0-1`
/// * `anchor` - The ``LiveViewNative/SwiftUI/UnitPoint`` to scale from
///
/// See [`SwiftUI.AnyTransition.scale`](https://developer.apple.com/documentation/swiftui/anytransition/scale(scale:anchor:)) for more details on this transition.
///
/// ### :slide
/// See [`SwiftUI.AnyTransition.slide`](https://developer.apple.com/documentation/swiftui/anytransition/slide) for more details on this transition.
///
/// ### :push
/// Arguments:
/// * `edge` - The side to push from
///
/// See [`SwiftUI.AnyTransition.push`](https://developer.apple.com/documentation/swiftui/anytransition/push(from:)) for more details on this transition.
///
/// ### :asymmetric
/// Arguments:
/// * `insertion` (required) - The transition to apply when the element is inserted
/// * `removal` (required) - The transition to apply when the element is removed
///
/// See [`SwiftUI.AnyTransition.asymmetric`](https://developer.apple.com/documentation/swiftui/anytransition/asymmetric(insertion:removal:)) for more details on this transition.
///
/// ### :modifier
/// Arguments:
/// * `active` (required) - The modifier to apply when the transition is active
/// * `identity` (required) - The modifier to apply when the transition is done
///
/// The arguments to this transition should be modifier stacks.
///
/// ```elixir
/// {:modifier, [active: foreground_style({:color, :red}), identity: foreground_style({:color, :green})]}
/// ```
///
/// ### :symbol_effect
/// Arguments:
/// * `effect` - The ``LiveViewNative/SwiftUI/SymbolEffectTransition`` to apply. Defaults to `automatic`.
/// * `options` - The ``LiveViewNative/SwiftUI/SymbolEffectOptions`` used to configure the transition.
///
/// ```elixir
/// :symbol_effect
/// {:symbol_effect, :appear}
/// {:symbol_effect, [:disappear, :up]}
/// {:symbol_effect, [:appear, :by_layer], [:repeating, {:speed, 0.2}]}
/// ```
///
/// See [`SwiftUI.AnyTransition.modifier`](https://developer.apple.com/documentation/swiftui/anytransition/modifier(active:identity:)) for more details on this transition.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension AnyTransition {
    init<R: RootRegistry>(from container: KeyedDecodingContainer<CodingKeys>, in _: R.Type = R.self) throws {
        switch try container.decode(TransitionType.self, forKey: .type) {
        case .identity:
            self = .identity
        case .opacity:
            self = .opacity
        case .slide:
            self = .slide
        case .move:
            self = .move(
                edge: try container.nestedContainer(keyedBy: CodingKeys.Move.self, forKey: .properties).decode(Edge.self, forKey: .edge)
            )
        case .offset:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Offset.self, forKey: .properties)
            self = .offset(
                x: try properties.decode(Double.self, forKey: .x),
                y: try properties.decode(Double.self, forKey: .y)
            )
        case .scale:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Scale.self, forKey: .properties)
            if let scale = try properties.decodeIfPresent(Double.self, forKey: .scale) {
                self = .scale(scale: scale, anchor: try properties.decodeIfPresent(UnitPoint.self, forKey: .anchor) ?? .center)
            } else {
                self = .scale
            }
        case .push:
            self = .push(
                from: try container.nestedContainer(keyedBy: CodingKeys.Push.self, forKey: .properties).decode(Edge.self, forKey: .edge)
            )
        case .asymmetric:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Asymmetric.self, forKey: .properties)
            self = .asymmetric(
                insertion: try Self(from: try properties.nestedContainer(keyedBy: CodingKeys.self, forKey: .insertion), in: R.self),
                removal: try Self(from: try properties.nestedContainer(keyedBy: CodingKeys.self, forKey: .removal), in: R.self)
            )
        case .combined:
            var transitionsContainer = try container.nestedContainer(keyedBy: CodingKeys.Combined.self, forKey: .properties)
                .nestedUnkeyedContainer(forKey: .transitions)
            var transitions = [Self]()
            while !transitionsContainer.isAtEnd {
                transitions.append(try Self(from: transitionsContainer.nestedContainer(keyedBy: CodingKeys.self), in: R.self))
            }
            self = transitions.dropFirst().reduce(transitions.first!, { $0.combined(with: $1) })
        case .animation:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Animation.self, forKey: .properties)
            self = try Self(from: properties.nestedContainer(keyedBy: CodingKeys.self, forKey: .transition), in: R.self)
                .animation(properties.decode(Animation.self, forKey: .animation))
        case .modifier:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Modifier.self, forKey: .properties)
            self = .modifier(
                active: AppliedModifiers<R>(try properties.decode(String.self, forKey: .active).replacingOccurrences(of: "&quot;", with: "\"")),
                identity: AppliedModifiers<R>(try properties.decode(String.self, forKey: .identity).replacingOccurrences(of: "&quot;", with: "\""))
            )
        case .symbolEffect:
            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                #if canImport(Symbols)
                self.init(
                    (try? container.decodeIfPresent(SymbolEffectTransition.self, forKey: .properties)) ?? .symbolEffect
                )
                #else
                self = .identity
                #endif
            } else {
                self = .identity
            }
        }
    }
    
    private struct AppliedModifiers<R: RootRegistry>: ViewModifier {
        let data: Data
        @ObservedElement private var element
        @LiveContext<R> private var context
        
        init(_ json: String) {
            self.data = Data(json.utf8)
        }
        
        func body(content: Content) -> some View {
            content.applyModifiers((try! makeJSONDecoder().decode([ModifierContainer<R>].self, from: data))[...], element: element, context: context.storage)
        }
    }
    
    enum TransitionType: String, Decodable {
        case identity
        case opacity
        case slide
        case move
        case offset
        case scale
        case push
        case asymmetric
        case combined
        case animation
        case modifier
        
        @available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
        case symbolEffect = "symbol_effect"
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        
        enum Move: String, CodingKey {
            case edge
        }
        
        enum Offset: String, CodingKey {
            case x
            case y
        }
        
        enum Scale: String, CodingKey {
            case scale
            case anchor
        }
        
        enum Push: String, CodingKey {
            case edge
        }
        
        enum Asymmetric: String, CodingKey {
            case insertion
            case removal
        }
        
        enum Combined: String, CodingKey {
            case transitions
        }
        
        enum Animation: String, CodingKey {
            case transition
            case animation
        }
        
        enum Modifier: String, CodingKey {
            case active
            case identity
        }
        
        enum SymbolEffect: String, CodingKey {
            case effect
            case options
        }
    }
}

#if canImport(Symbols)
import Symbols

/// A transition applied to a system image.
///
/// Possible values:
/// * `automatic`
/// * `appear` - Supports the options `up`, `down`, `by_layer`, and `whole_symbol`.
/// * `disappear` - Supports the options `up`, `down`, `by_layer`, and `whole_symbol`.
///
/// ```elixir
/// :automatic
/// :disappear
/// [:appear, :down, :by_layer]
/// ````
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension SymbolEffectTransition: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let effect: any (SymbolEffect & TransitionSymbolEffect)
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
        
        self.init(
            effect: effect,
            options: try container.decode(SymbolEffectOptions.self, forKey: .options)
        )
    }
    
    enum CodingKeys: CodingKey {
        case effect
        case options
    }
    
    enum TransitionSymbolEffectType: String, Decodable {
        case automatic
        case appear
        case disappear
        
        func effect(options: [String]) -> any (SymbolEffect & TransitionSymbolEffect) {
            switch self {
            case .automatic:
                return AutomaticSymbolEffect.automatic
            case .appear:
                var result = AppearSymbolEffect.appear
                for option in options {
                    switch option {
                    case "up": result = result.up
                    case "down": result = result.down
                    case "by_layer": result = result.byLayer
                    case "whole_symbol": result = result.wholeSymbol
                    default: continue
                    }
                }
                return result
            case .disappear:
                var result = DisappearSymbolEffect.disappear
                for option in options {
                    switch option {
                    case "up": result = result.up
                    case "down": result = result.down
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

/// Options applied to a symbol effect.
///
/// ### :repeating
/// Causes the effect to repeat indefinitely.
///
/// ### :non_repeating
/// Disables repeating of the effect.
///
/// ### :speed
/// The speed multiplier.
///
/// ```elixir
/// {:speed, 0.25}
/// ```
///
/// ### :repeat
/// Repeat a specified number of times.
///
/// ```elixir
/// {:repeat, 3}
/// ```
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension SymbolEffectOptions: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self = .default
        while !container.isAtEnd {
            if let value = try? container.decode(String.self) {
                switch value {
                case "repeating":
                    self = self.repeating
                case "non_repeating":
                    self = self.nonRepeating
                case let `default`:
                    throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown symbol effect option '\(`default`)'"))
                }
            } else {
                let option = try container.nestedContainer(keyedBy: CodingKeys.self)
                switch try option.decode(OptionType.self, forKey: .type) {
                case .speed:
                    self = self.speed(try option.decode(Double.self, forKey: .properties))
                case .repeat:
                    self = self.repeat(try option.decodeIfPresent(Int.self, forKey: .properties))
                }
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case type
        case properties
    }
    
    enum OptionType: String, Decodable {
        case speed
        case `repeat`
    }
}
#endif
