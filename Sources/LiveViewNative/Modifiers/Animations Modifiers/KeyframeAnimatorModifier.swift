//
//  KeyframeAnimatorModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 6/7/2023.
//

import SwiftUI

/// Use keyframes to animate specific modifiers.
///
/// There is no noticeable latency when using keyframe animations, as all values are calculated on-device.
///
/// The keyframe values will replace the listed ``properties`` of the modifiers.
///
/// - Note: Only numeric properties can be animated.
///
/// ```html
/// <Image
///   system-name="heart.fill"
///   modifiers={
///     keyframe_animator(
///       initial_value: 1.0,
///       trigger: "#{@liked}",
///       keyframes: [
///         {:linear, 1.0, [duration: 0.36]},
///         {:spring, 1.5, [duration: 0.8, spring: :bouncy]},
///         {:spring, 1.0, [spring: :bouncy]}
///       ],
///       modifiers: scale_effect(x: 1.0, y: 1.0),
///       properties: [scale_effect: [:x, :y]]
///     )
///   }
/// />
/// ```
///
/// When the `@liked` assign changes, the image will scale up then back down.
/// The `x` and `y` properties in the ``ScaleEffectModifier`` modifier passed to the ``modifiers`` argument will be replaced for each frame.
///
/// ## Arguments
/// * ``initialValue``
/// * ``trigger``
/// * ``keyframes``
/// * ``modifiers``
/// * ``properties``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
struct KeyframeAnimatorModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The initial value of the animation.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let initialValue: Double
    
    /// A string that, when changed, triggers the animation.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let trigger: String
    
    /// A list of keyframes to animate with.
    /// See ``LiveViewNative/KeyframeAnimation/Keyframe`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let keyframes: [KeyframeAnimation.Keyframe]
    
    #if !swift(>=5.9)
    enum KeyframeAnimation {
        struct Keyframe: Decodable {
            init(from decoder: Decoder) throws {}
        }
    }
    #endif
    
    /// The modifier stack to animate.
    ///
    /// The modifier stack is created with the `@native` assign and modifier functions.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let modifiers: String
    
    /// A list of atoms with the names of the modifier's properties to animate.
    ///
    /// For example, to animate the `y` property of an ``OffsetModifier`` modifier:
    ///
    /// ```elixir
    /// [offset: [:y]]
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let properties: [String:[String]]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.initialValue = try container.decode(Double.self, forKey: .initialValue)
        self.trigger = try container.decode(String.self, forKey: .trigger)
        self.keyframes = try container.decode([KeyframeAnimation.Keyframe].self, forKey: .keyframes)
        self.modifiers = try container.decode(String.self, forKey: .modifiers)
        self.properties = try container.decode([String:[String]].self, forKey: .properties)
    }
    
    func body(content: Content) -> some View {
        content
            #if swift(>=5.9)
            .keyframeAnimator(
                initialValue: initialValue,
                trigger: trigger
            ) { content, value in
                if let applicator = try? Applicator(modifiers, value: value, properties: properties, content: content) {
                    applicator
                } else {
                    content
                }
            } keyframes: { value in
                KeyframeTrack(\.self) {
                    KeyframeTrackContentBuilder.buildArray(keyframes.map(\.value))
                }
            }
            #endif
    }
    
    enum CodingKeys: CodingKey {
        case initialValue
        case trigger
        case keyframes
        case modifiers
        case properties
    }
    
    private struct Applicator<Content: View>: View {
        let stack: [ModifierContainer<R>]
        let content: Content
        
        @ObservedElement private var element
        @LiveContext<R> private var context
        
        nonisolated init(_ modifiers: String, value: Double, properties: [String:[String]], content: Content) throws {
            self.content = content
            
            let modified = NSArray(array: (try JSONSerialization.jsonObject(with: Data(modifiers.utf8)) as! [[NSString:Any]])
                .compactMap({ (modifier) -> NSDictionary? in
                    guard let type = modifier["type"] as? String
                    else { return nil }
                    return Dictionary<NSString, Any>(uniqueKeysWithValues: modifier.map({
                        if (properties[type]?.contains(String($0.key)) ?? false) {
                            return ($0.key, NSNumber(value: value) as Any)
                        } else {
                            return ($0.key, $0.value)
                        }
                    })) as NSDictionary
                })) as NSArray
            let encoded = try JSONSerialization.data(withJSONObject: modified, options: .sortedKeys)
            self.stack = try makeJSONDecoder().decode([ModifierContainer<R>].self, from: encoded)
        }
        
        var body: some View {
            content
                .applyModifiers(stack[...], element: element, context: context.storage)
        }
    }
}
