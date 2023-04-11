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
/// {:modifier, [active: foreground_style(@native, primary: {:color, :red}), identity: foreground_style(@native, primary: {:color, :green})]}
/// ```
///
/// See [`SwiftUI.AnyTransition.modifier`](https://developer.apple.com/documentation/swiftui/anytransition/modifier(active:identity:)) for more details on this transition.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension AnyTransition: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
                insertion: try properties.decode(Self.self, forKey: .insertion),
                removal: try properties.decode(Self.self, forKey: .removal)
            )
        case .combined:
            let transitions = try container.nestedContainer(keyedBy: CodingKeys.Combined.self, forKey: .properties).decode([Self].self, forKey: .transitions)
            self = transitions.dropFirst().reduce(transitions.first!, { $0.combined(with: $1) })
        case .animation:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Animation.self, forKey: .properties)
            self = try properties.decode(Self.self, forKey: .transition)
                .animation(properties.decode(Animation.self, forKey: .animation))
        case .modifier:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Modifier.self, forKey: .properties)
            self = .modifier(
                active: AppliedModifiers(try properties.decode(String.self, forKey: .active).replacingOccurrences(of: "&quot;", with: "\"")),
                identity: AppliedModifiers(try properties.decode(String.self, forKey: .identity).replacingOccurrences(of: "&quot;", with: "\""))
            )
        }
    }
    
    private struct AppliedModifiers: ViewModifier {
        let data: Data
        
        init(_ json: String) {
            self.data = Data(json.utf8)
        }
        
        func body(content: Content) -> some View {
            content.applyModifiers((try! JSONDecoder().decode([ModifierContainer<EmptyRegistry>].self, from: data))[...])
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
    }
}
