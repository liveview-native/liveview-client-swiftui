//
//  Gesture.swift
//  
//
//  Created by Carson Katri on 4/20/23.
//

import SwiftUI

/// Configuration for the ``GestureModifier`` modifier.
///
/// In their simplest form, gestures can be created with an atom. More complex gestures can have properties.
///
/// ```elixir
/// :tap
/// {:tap, [count: 2]} # a double tap
/// {:sequential, [:long_press, {:tap, [count: 2]}]} # a sequence of gestures
/// ```
///
/// ## Gestures
/// Gestures with no required arguments can be represented with an atom.
///
/// ```elixir
/// :tap
/// ```
///
/// To pass arguments, use a tuple with a keyword list as the second element.
///
/// ```elixir
/// {:tap, [count: 2]}
/// ```
///
/// ### :tap
/// Arguments:
/// * `count` - The number of taps needed to trigger the event.
///
/// See [`SwiftUI.TapGesture`](https://developer.apple.com/documentation/swiftui/tapgesture) for more details on this gesture.
///
/// ### :spatial_tap
/// Arguments:
/// * `count` - The number of taps needed to trigger the event.
/// * `coordinate_space` - The coordinate space to report the tap location in. See ``LiveViewNative/SwiftUI/CoordinateSpace`` for a list of possible values.
///
/// See [`SwiftUI.SpatialTapGesture`](https://developer.apple.com/documentation/swiftui/spatialtapgesture) for more details on this gesture.
///
/// ### :long_press
/// Arguments:
/// * `minimum_duration` - The minimum duration the press must be before succeeding.
/// * `maximum_distance` - The maximum distance the cursor can move before the gesture fails.
///
/// See [`SwiftUI.LongPressGesture`](https://developer.apple.com/documentation/swiftui/longpressgesture) for more details on this gesture.
///
/// ### Sequential Gestures
/// Gestures can be performed in sequence by passing an array.
///
/// ```elixir
/// {:sequential, [:long_press, {:spatial_tap, [count: 2]}]}
/// ```
///
/// In this example, the user must long press then tap again for the event to be sent.
///
/// ### Simultaneous Gestures
/// All of the gestures passed will be observed at the same time.
///
/// ```elixir
/// {:simultaneous, [:tap, :spatial_tap]}
/// ```
///
/// In this example, the `tap` and `spatial_tap` results will be sent together in an array.
///
/// ### Exclusive Gestures
/// One of the options will be performed, but not both.
/// The first gesture is given precedence.
///
/// ```elixir
/// {:exclusive, [:long_press, {:spatial_tap, [count: 2]}]}
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension AnyGesture: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        
        enum Tap: String, CodingKey {
            case count
        }
        
        enum SpatialTap: String, CodingKey {
            case count
            case coordinateSpace
        }
        
        enum LongPress: String, CodingKey {
            case minimumDuration
            case maximumDistance
        }
        
        enum Sequence: String, CodingKey {
            case gestures
        }
    }
    
    enum GestureType: String, Decodable {
        case tap
        #if !os(tvOS)
        case spatialTap = "spatial_tap"
        case longPress = "long_press"
        #endif
        case sequential
        case simultaneous
        case exclusive
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(GestureType.self, forKey: .type) {
        case .tap:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Tap.self, forKey: .properties)
            self = .init(
                TapGesture(
                    count: try properties.decodeIfPresent(Int.self, forKey: .count) ?? 1
                )
                .map { _ in [String:String]() as! Value }
            )
        #if !os(tvOS)
        case .spatialTap:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.SpatialTap.self, forKey: .properties)
            self = .init(
                SpatialTapGesture(
                    count: try properties.decodeIfPresent(Int.self, forKey: .count) ?? 1,
                    coordinateSpace: try properties.decodeIfPresent(CoordinateSpace.self, forKey: .coordinateSpace) ?? .local
                )
                .map { ["x": $0.location.x, "y": $0.location.y] as! Value }
            )
        case .longPress:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.LongPress.self, forKey: .properties)
            self = .init(
                LongPressGesture(
                    minimumDuration: try properties.decodeIfPresent(Double.self, forKey: .minimumDuration) ?? 0.5,
                    maximumDistance: try properties.decodeIfPresent(Double.self, forKey: .maximumDistance) ?? 10
                )
                .map { $0 as! Value }
            )
        #endif
        case .sequential:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Sequence.self, forKey: .properties)
            let sequence = try properties.decode([AnyGesture<Value>].self, forKey: .gestures)
            self = sequence.dropFirst().reduce(sequence.first!) { first, second in
                AnyGesture<Value>(
                    SequenceGesture(first, second)
                        .map {
                            switch $0 {
                            case let .first(first):
                                return first
                            case let .second(first, second):
                                if let array = first as? [Any] {
                                    return (array + [second as Any]) as! Value
                                } else {
                                    return [first, second] as! Value
                                }
                            }
                        }
                )
            }
        case .simultaneous:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Sequence.self, forKey: .properties)
            let sequence = try properties.decode([AnyGesture<Value>].self, forKey: .gestures)
            self = sequence.dropFirst().reduce(sequence.first!) { first, second in
                AnyGesture<Value>(
                    SimultaneousGesture(first, second)
                        .map {
                            if let array = $0.first as? [Any] {
                                return (array + [$0.second as Any]) as! Value
                            } else {
                                return [$0.first, $0.second] as! Value
                            }
                        }
                )
            }
        case .exclusive:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Sequence.self, forKey: .properties)
            let sequence = try properties.decode([AnyGesture<Value>].self, forKey: .gestures)
            self = sequence.dropFirst().reduce(sequence.first!) { first, second in
                AnyGesture<Value>(
                    ExclusiveGesture(first, second)
                        .map {
                            switch $0 {
                            case let .first(first):
                                return first
                            case let .second(second):
                                return second
                            }
                        }
                )
            }
        }
    }
}
