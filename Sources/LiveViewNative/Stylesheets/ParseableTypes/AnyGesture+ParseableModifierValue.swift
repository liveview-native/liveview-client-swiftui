//
//  AnyGesture+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Gesture`](https://developer.apple.com/documentation/swiftui/Gesture) for more details.
///
/// ## Gestures
/// ### Drag
/// Detect swipes or drags across on an element.
/// 
/// Optionally provide a `minimumDistance` and `coordinateSpace` as an ``AnyCoordinateSpaceProtocol``.
///
/// ```swift
/// DragGesture()
/// DragGesture(minimumDistance: 0, coordinateSpace: .global)
/// ```
///
/// ### Long Press
/// Detect tap/click and hold on an element.
///
/// Optionally provide a `minimumDuration` and `maximumDistance`.
///
/// ```swift
/// LongPressGesture()
/// LongPressGesture(minimumDuration: 1, maximumDistance: 30)
/// ```
///
/// ### Magnify
/// Detect pinch and zoom gestures on an element.
///
/// Optionally provide a `minimumScaleDelta`.
///
/// ```swift
/// MagnifyGesture()
/// MagnifyGesture(minimumScaleDelta: 0.1)
/// ```
///
/// ### Rotate
/// Detect two finger rotation gestures on an element.
///
/// Optionally provide a `minimumAngleDelta` as a ``SwiftUI/Angle``.
///
/// ```swift
/// RotateGesture()
/// RotateGesture(minimumAngleDelta: .degrees(10))
/// ```
///
/// ### Spatial Tap
/// A tap/click gesture that reports the position of the tap.
///
/// Optionally provide a `count` and `coordinateSpace` as an ``AnyCoordinateSpaceProtocol``.
///
/// ```swift
/// SpatialTapGesture()
/// SpatialTapGesture(count: 2, coordinateSpace: .global)
/// ```
///
/// ### Tap
/// A tap/click gesture.
///
/// Optionally provide a `count`.
///
/// ```swift
/// TapGesture()
/// TapGesture(count: 2)
/// ```
///
/// ## Gesture Modifiers
/// Modify and receive events from gestures by applying modifiers to them.
///
/// ### Sequencing Gestures
/// Only receive events after the first gesture succeeds.
///
/// ```swift
/// DragGesture().sequenced(before: TapGesture())
/// ```
///
/// ### Simultaneous Gestures
/// Combine gestures where both can receive events at the same time.
///
/// ```swift
/// RotateGesture().simultaneously(with: MagnifyGesture())
/// ```
///
/// ### Exclusive Gestures
/// Combine gestures where only one can receive events at time. Priority is given to the first gesture.
///
/// ```swift
/// RotateGesture().exclusively(before: MagnifyGesture())
/// ```
///
/// ### Receiving Events
/// Use `onEnded` to receive an event when the gesture ends.
///
/// ```swift
/// SpatialTapGesture().onEnded(event("tapped"))
/// ```
///
/// ```elixir
/// def handle_event("tapped", gesture_value, socket), do: ...
/// ```
@_documentation(visibility: public)
struct _AnyGesture: ParseableModifierValue {
    let gesture: AnyGesture<Any>
    let members: [Member]
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> AnyGesture<Any> {
        members.reduce(gesture) { gesture, member in
            member.apply(to: gesture, on: element, in: context)
        }
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            baseParser(in: context)
        } member: {
            Member.parser(in: context)
        }
        .map { (base, members) in
            self.init(gesture: base, members: members)
        }
    }
    
    enum Member: ParseableModifierValue {
        case sequenced(Sequenced)
        case simultaneously(Simultaneously)
        case onEnded(OnEnded)
        case exclusively(Exclusively)
        case updating(Updating)
        
        @ParseableExpression
        struct Sequenced {
            static let name = "sequenced"
            
            let other: _AnyGesture
            
            init(before other: _AnyGesture) {
                self.other = other
            }
        }
        
        @ParseableExpression
        struct Simultaneously {
            static let name = "simultaneously"
            
            let other: _AnyGesture
            
            init(with other: _AnyGesture) {
                self.other = other
            }
        }
        
        @ParseableExpression
        struct OnEnded {
            static let name = "onEnded"
            
            @Event var action: Event.EventHandler
            
            init(_ action: Event) {
                self._action = action
            }
        }
        
        @ParseableExpression
        struct Exclusively {
            static let name = "exclusively"
            
            let other: _AnyGesture
            
            init(before other: _AnyGesture) {
                self.other = other
            }
        }
        
        @ParseableExpression
        struct Updating {
            static let name = "updating"
            
            let name: String
            
            init(_ name: String) {
                self.name = name
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                Sequenced.parser(in: context).map(Self.sequenced)
                Simultaneously.parser(in: context).map(Self.simultaneously)
                OnEnded.parser(in: context).map(Self.onEnded)
                Exclusively.parser(in: context).map(Self.exclusively)
                Updating.parser(in: context).map(Self.updating)
            }
        }
        
        func apply<R: RootRegistry>(to gesture: AnyGesture<Any>, on element: ElementNode, in context: LiveContext<R>) -> AnyGesture<Any> {
            switch self {
            case .sequenced(let sequenced):
                return AnyGesture<Any>(gesture.sequenced(before: sequenced.other.resolve(on: element, in: context)).map({ $0 as Any }))
            case .simultaneously(let simultaneously):
                return AnyGesture<Any>(gesture.simultaneously(with: simultaneously.other.resolve(on: element, in: context)).map({ $0 as Any }))
            case .onEnded(let onEnded):
                return AnyGesture<Any>(gesture.onEnded({ value in
                    Task {
                        await onEnded.action(value: value)
                    }
                }).map({ $0 as Any }))
            case .exclusively(let exclusively):
                return AnyGesture<Any>(gesture.exclusively(before: exclusively.other.resolve(on: element, in: context)).map({ $0 as Any }))
            case .updating(let updating):
                return AnyGesture<Any>(
                    gesture.updating(context.gestureState, body: { value, state, transaction in
                        state[updating.name] = value
                    })
                )
            }
        }
    }
    
    static func baseParser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, AnyGesture<Any>> {
        OneOf {
            #if !os(tvOS)
            Drag.parser(in: context).map({ AnyGesture<Any>($0.value.map({ $0 as Any })) })
            #endif
            LongPress.parser(in: context).map({ AnyGesture<Any>($0.value.map({ $0 as Any })) })
            #if os(iOS) || os(macOS)
            Magnify.parser(in: context).map({ AnyGesture<Any>($0.value.map({ $0 as Any })) })
            Rotate.parser(in: context).map({ AnyGesture<Any>($0.value.map({ $0 as Any })) })
            #endif
            #if !os(tvOS)
            SpatialTap.parser(in: context).map({ AnyGesture<Any>($0.value.map({ $0 as Any })) })
            #endif
            Tap.parser(in: context).map({ AnyGesture<Any>($0.value.map({ $0 as Any })) })
        }
    }
    
    #if !os(tvOS)
    @ParseableExpression
    struct Drag {
        static let name = "DragGesture"
        let value: DragGesture
        
        init(minimumDistance: CGFloat = 10, coordinateSpace: AnyCoordinateSpaceProtocol = .local) {
            self.value = .init(minimumDistance: minimumDistance, coordinateSpace: coordinateSpace.coordinateSpace)
        }
    }
    #endif
    
    @ParseableExpression
    struct LongPress {
        static let name = "LongPressGesture"
        let value: LongPressGesture
        
        #if os(tvOS)
        init(minimumDuration: Double = 0.5) {
            self.value = .init(minimumDuration: minimumDuration)
        }
        #else
        init(minimumDuration: Double = 0.5, maximumDistance: CGFloat = 10) {
            self.value = .init(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        }
        #endif
    }
    
    #if os(iOS) || os(macOS) || os(visionOS)
    @ParseableExpression
    struct Magnify {
        static let name = "MagnifyGesture"
        let value: AnyGesture<Any>
        
        init(minimumScaleDelta: CGFloat = 0.01) {
            if #available(iOS 17, macOS 14, *) {
                self.value = .init(MagnifyGesture.init(minimumScaleDelta: minimumScaleDelta).map({ $0 as Any }))
            } else {
                self.value = .init(MagnificationGesture.init(minimumScaleDelta: minimumScaleDelta).map({ $0 as Any }))
            }
        }
    }
    
    @ParseableExpression
    struct Rotate {
        static let name = "RotateGesture"
        let value: AnyGesture<Any>
        
        init(minimumAngleDelta: Angle = .degrees(1)) {
            if #available(iOS 17, macOS 14, *) {
                self.value = .init(RotateGesture.init(minimumAngleDelta: minimumAngleDelta).map({ $0 as Any }))
            } else {
                self.value = .init(RotationGesture.init(minimumAngleDelta: minimumAngleDelta).map({ $0 as Any }))
            }
        }
    }
    #endif
    
    #if !os(tvOS)
    @ParseableExpression
    struct SpatialTap {
        static let name = "SpatialTapGesture"
        let value: SpatialTapGesture
        
        init(count: Int = 1, coordinateSpace: AnyCoordinateSpaceProtocol = .local) {
            self.value = .init(count: count, coordinateSpace: coordinateSpace.coordinateSpace)
        }
    }
    #endif
    
    @ParseableExpression
    struct Tap {
        static let name = "TapGesture"
        let value: TapGesture
        
        init(count: Int = 1) {
            self.value = .init(count: count)
        }
    }
}

extension EnvironmentValues {
    private enum GestureStateKey: EnvironmentKey {
        static let defaultValue: GestureState<[String:Any]> = .init(initialValue: [:])
    }
    
    var gestureState: GestureState<[String:Any]> {
        get { self[GestureStateKey.self] }
        set { self[GestureStateKey.self] = newValue }
    }
}
