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
    case drag(_DragGesture)
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let modifiedContent = try? container.decode(MemberAccess<Self, StylesheetResolvableGestureModifier>.self) {
            self = .modified(modifiedContent.base, modifiedContent.member)
            return
        }
        
        if let gesture = try? container.decode(_DragGesture.self) {
            self = .drag(gesture)
            return
        }
        
        throw BuiltinRegistryModifierError.unknownModifier
    }
    
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> AnyGesture<Any> {
        switch self {
        case let .modified(base, modifier):
            return modifier.resolve(on: element, in: context, appliedTo: base.resolve(on: element, in: context))
        case let .drag(drag):
            return AnyGesture(
                drag.resolve(on: element, in: context)
                    .map({ $0 as Any })
            )
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

extension StylesheetResolvableGesture: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}

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
