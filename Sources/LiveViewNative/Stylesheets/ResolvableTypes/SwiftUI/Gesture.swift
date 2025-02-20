//
//  Gesture.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

indirect enum StylesheetResolvableGesture: StylesheetResolvable, @preconcurrency Decodable {
    case modified(Self, StylesheetResolvableGestureModifier)
    case tap(_TapGesture)
    case drag(_DragGesture)
    case spatialTap(_SpatialTapGesture)
    case longPress(_LongPressGesture)
    case magnify(Any)
    case rotate(Any)
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let modifiedContent = try? container.decode(MemberAccess<Self, StylesheetResolvableGestureModifier>.self) {
            self = .modified(modifiedContent.base, modifiedContent.member)
            return
        }
        
        if let gesture = try? container.decode(_TapGesture.self) {
            self = .tap(gesture)
            return
        }
        
        if let gesture = try? container.decode(_DragGesture.self) {
            self = .drag(gesture)
            return
        }
        
        if let gesture = try? container.decode(_SpatialTapGesture.self) {
            self = .spatialTap(gesture)
            return
        }
        
        if let gesture = try? container.decode(_LongPressGesture.self) {
            self = .longPress(gesture)
            return
        }
        
        if #available(iOS 17.0, macOS 14.0, *) {
            if let gesture = try? container.decode(_MagnifyGesture.self) {
                self = .magnify(gesture)
                return
            }
            
            if let gesture = try? container.decode(_RotateGesture.self) {
                self = .rotate(gesture)
                return
            }
        }
        
        throw BuiltinRegistryModifierError.unknownModifier
    }
    
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> AnyGesture<Any> {
        switch self {
        case let .modified(base, modifier):
            return modifier.resolve(on: element, in: context, appliedTo: base.resolve(on: element, in: context))
        case let .tap(tap):
            return AnyGesture(
                tap.resolve(on: element, in: context)
                    .map({ $0 as Any })
            )
        case let .drag(drag):
            return AnyGesture(
                drag.resolve(on: element, in: context)
                    .map({ $0 as Any })
            )
        case let .spatialTap(spatialTap):
            return AnyGesture(
                spatialTap.resolve(on: element, in: context)
                    .map({ $0 as Any })
            )
        case let .longPress(longPress):
            return AnyGesture(
                longPress.resolve(on: element, in: context)
                    .map({ $0 as Any })
            )
        case let .magnify(magnify):
            if #available(iOS 17.0, macOS 14.0, *) {
                return AnyGesture(
                    (magnify as! _MagnifyGesture).resolve(on: element, in: context)
                        .map({ $0 as Any })
                )
            } else {
                fatalError("MagnifyGesture is not available")
            }
        case let .rotate(rotate):
            if #available(iOS 17.0, macOS 14.0, *) {
                return AnyGesture(
                    (rotate as! _RotateGesture).resolve(on: element, in: context)
                        .map({ $0 as Any })
                )
            } else {
                fatalError("RotateGesture is not available")
            }
        }
    }
}

indirect enum StylesheetResolvableGestureModifier: @preconcurrency Decodable {
    case updating(Updating)
    
    @ASTDecodable("updating")
    struct Updating: @preconcurrency Decodable {
        let reference: AttributeReference<AtomLiteral>
        
        init(_ reference: AttributeReference<AtomLiteral>) {
            self.reference = reference
        }
    }
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.singleValueContainer()
        
        if let modifier = try? container.decode(Updating.self) {
            self = .updating(modifier)
            return
        }
        
        throw BuiltinRegistryModifierError.unknownModifier
    }
    
    @MainActor
    func resolve<R>(
        on element: ElementNode,
        in context: LiveContext<R>,
        appliedTo gesture: AnyGesture<Any>
    ) -> AnyGesture<Any> where R : RootRegistry {
        switch self {
        case let .updating(updating):
            let key = updating.reference.resolve(on: element, in: context).value
            return AnyGesture(
                gesture.updating(context.gestureState) { value, state, transaction in
                    state[key] = value
                }
            )
        }
    }
}

@ASTDecodable("DragGesture")
struct _DragGesture: @preconcurrency Decodable, StylesheetResolvable {
    let minimumDistance: CGFloat.Resolvable
    let coordinateSpace: CoordinateSpace.Resolvable
    
    init(
        minimumDistance: CGFloat.Resolvable = .__constant(10),
        coordinateSpace: CoordinateSpace.Resolvable = .__constant(.local)
    ) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> DragGesture where R : RootRegistry {
        DragGesture(
            minimumDistance: minimumDistance.resolve(on: element, in: context),
            coordinateSpace: coordinateSpace.resolve(on: element, in: context)
        )
    }
}

@ASTDecodable("TapGesture")
struct _TapGesture: @preconcurrency Decodable, StylesheetResolvable {
    let count: AttributeReference<Int>
    
    init(count: AttributeReference<Int> = .constant(1)) {
        self.count = count
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> TapGesture where R : RootRegistry {
        TapGesture(count: count.resolve(on: element, in: context))
    }
}

@ASTDecodable("SpatialTapGesture")
struct _SpatialTapGesture: @preconcurrency Decodable, StylesheetResolvable {
    let count: AttributeReference<Int>
    let coordinateSpace: CoordinateSpace.Resolvable
    
    init(
        count: AttributeReference<Int> = .constant(1),
        coordinateSpace: CoordinateSpace.Resolvable = .__constant(.local)
    ) {
        self.count = count
        self.coordinateSpace = coordinateSpace
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> SpatialTapGesture where R : RootRegistry {
        SpatialTapGesture(
            count: count.resolve(on: element, in: context),
            coordinateSpace: coordinateSpace.resolve(on: element, in: context)
        )
    }
}

@ASTDecodable("LongPressGesture")
struct _LongPressGesture: @preconcurrency Decodable, StylesheetResolvable {
    let minimumDuration: Double.Resolvable
    let maximumDistance: CGFloat.Resolvable
    
    init(
        minimumDuration: Double.Resolvable = .__constant(0.5),
        maximumDistance: CGFloat.Resolvable = .__constant(10)
    ) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> LongPressGesture where R : RootRegistry {
        LongPressGesture(
            minimumDuration: minimumDuration.resolve(on: element, in: context),
            maximumDistance: maximumDistance.resolve(on: element, in: context)
        )
    }
}

@ASTDecodable("MagnifyGesture")
@available(iOS 17.0, macOS 14.0, *)
struct _MagnifyGesture: @preconcurrency Decodable, StylesheetResolvable {
    let minimumScaleDelta: CGFloat.Resolvable
    
    init(
        minimumScaleDelta: CGFloat.Resolvable = .__constant(0.01)
    ) {
        self.minimumScaleDelta = minimumScaleDelta
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> MagnifyGesture where R : RootRegistry {
        MagnifyGesture(
            minimumScaleDelta: minimumScaleDelta.resolve(on: element, in: context)
        )
    }
}

@ASTDecodable("RotateGesture")
@available(iOS 17.0, macOS 14.0, *)
struct _RotateGesture: @preconcurrency Decodable, StylesheetResolvable {
    let minimumAngleDelta: Angle.Resolvable
    
    init(
        minimumAngleDelta: Angle.Resolvable = .__constant(.degrees(1))
    ) {
        self.minimumAngleDelta = minimumAngleDelta
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> RotateGesture where R : RootRegistry {
        RotateGesture(
            minimumAngleDelta: minimumAngleDelta.resolve(on: element, in: context)
        )
    }
}

extension StylesheetResolvableGesture: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}

#if os(iOS)
@ASTDecodable("UIGestureRecognizerRepresentable")
enum StylesheetResolvableUIGestureRecognizerRepresentable: @preconcurrency UIGestureRecognizerRepresentable, StylesheetResolvable, @preconcurrency Decodable {
    case drag
    
    func makeUIGestureRecognizer(context: Context) -> some UIGestureRecognizer {
        UISwipeGestureRecognizer()
    }
}

extension StylesheetResolvableUIGestureRecognizerRepresentable {
    @MainActor
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        return self
    }
}

extension StylesheetResolvableUIGestureRecognizerRepresentable: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}
#endif

extension EnvironmentValues {
    enum GestureStateKey: @preconcurrency EnvironmentKey {
        @MainActor static let defaultValue = GestureState<[String:Any]>(wrappedValue: [:])
    }
    
    var gestureState: GestureState<[String:Any]> {
        get {
            self[GestureStateKey.self]
        } set {
            self[GestureStateKey.self] = newValue
        }
    }
}
