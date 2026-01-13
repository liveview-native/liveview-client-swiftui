import SwiftUI
import SwiftSyntax
import LightpandaClient

// MARK: - GestureMask

extension GestureMask: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access like .all, .gesture, .subviews, .none
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "all":
                self = .all
            case "gesture":
                self = .gesture
            case "subviews":
                self = .subviews
            case "none":
                self = .none
            default:
                return nil
            }
            return
        }
        return nil
    }
}

// MARK: - ParsedCoordinateSpace

/// A parsed coordinate space that can be used with DragGesture.
/// Supports .local, .global, and .named("name") coordinate spaces.
public enum ParsedCoordinateSpace: Sendable, Equatable {
    case local
    case global
    case named(String)

    /// Convert to SwiftUI's CoordinateSpace for use with gestures.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    var coordinateSpace: CoordinateSpace {
        switch self {
        case .local:
            return .local
        case .global:
            return .global
        case .named(let name):
            return .named(name)
        }
    }
}

extension ParsedCoordinateSpace: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        // Handle member access like .local, .global
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "local":
                self = .local
            case "global":
                self = .global
            default:
                return nil
            }
            return
        }

        // Handle function call like .named("mySpace")
        if let functionCall = syntax.as(FunctionCallExprSyntax.self),
           let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil,
           memberAccess.declName.baseName.text == "named",
           let name = functionCall.arguments.first.flatMap({ String(syntax: $0.expression) }) {
            self = .named(name)
            return
        }

        return nil
    }
}

// MARK: - ParsedGesture

/// A fully parsed gesture including base type, composition, and callback event names.
/// Can be converted to `AnyGesture<Void>` for application to views.
///
/// Usage:
/// ```html
/// <!-- Simple gesture with callbacks -->
/// <vstack modifiers="gesture(DragGesture().onChanged(dragging).onEnded(dragEnd))">
///
/// <!-- Composed gesture -->
/// <vstack modifiers="gesture(LongPressGesture().sequenced(before: DragGesture()).onEnded(dragAfterPress))">
///
/// <!-- Simultaneous gestures -->
/// <vstack modifiers="gesture(MagnificationGesture().simultaneously(with: RotationGesture()).onChanged(transform))">
/// ```
public struct ParsedGesture: Sendable {
    /// The base gesture type with its parameters.
    public let base: BaseGesture

    /// Event name to dispatch on gesture change (for continuous gestures).
    public let onChanged: String?

    /// Event name to dispatch on gesture end.
    public let onEnded: String?

    /// Base gesture types.
    public indirect enum BaseGesture: Sendable {
        case drag(minimumDistance: CGFloat, coordinateSpace: ParsedCoordinateSpace)
        case magnification(minimumScaleDelta: CGFloat)
        case rotation(minimumAngleDelta: Angle)
        case longPress(minimumDuration: Double, maximumDistance: CGFloat)
        case tap(count: Int)

        // Composed gestures
        case sequenced(first: BaseGesture, second: BaseGesture)
        case simultaneous(first: BaseGesture, second: BaseGesture)
        case exclusive(first: BaseGesture, second: BaseGesture)
    }

    public init(base: BaseGesture, onChanged: String? = nil, onEnded: String? = nil) {
        self.base = base
        self.onChanged = onChanged
        self.onEnded = onEnded
    }
}

extension ParsedGesture: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self) else {
            return nil
        }

        // Parse the gesture chain, collecting onChanged/onEnded along the way
        var onChanged: String? = nil
        var onEnded: String? = nil
        var currentSyntax: FunctionCallExprSyntax = functionCall

        // Walk up the chain to find onChanged/onEnded calls
        while let memberAccess = currentSyntax.calledExpression.as(MemberAccessExprSyntax.self),
              let baseFunctionCall = memberAccess.base?.as(FunctionCallExprSyntax.self) {
            let methodName = memberAccess.declName.baseName.text

            if methodName == "onChanged" {
                // Extract event name from first argument (identifier)
                onChanged = currentSyntax.arguments.first
                    .flatMap { $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }
                currentSyntax = baseFunctionCall
            } else if methodName == "onEnded" {
                // Extract event name from first argument (identifier)
                onEnded = currentSyntax.arguments.first
                    .flatMap { $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }
                currentSyntax = baseFunctionCall
            } else {
                // Not a callback method, stop here
                break
            }
        }

        // Now parse the base gesture from currentSyntax
        guard let baseGesture = BaseGesture(syntax: currentSyntax) else {
            return nil
        }

        self.base = baseGesture
        self.onChanged = onChanged
        self.onEnded = onEnded
    }
}

extension ParsedGesture.BaseGesture: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self) else {
            return nil
        }

        // Check if this is a composed gesture (method call on another gesture)
        if let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
           let baseGesture = memberAccess.base.flatMap({ ParsedGesture.BaseGesture(syntax: $0) }) {
            let methodName = memberAccess.declName.baseName.text

            switch methodName {
            case "sequenced":
                guard let beforeArg = functionCall.argument(named: "before"),
                      let secondGesture = ParsedGesture.BaseGesture(syntax: beforeArg.expression) else {
                    return nil
                }
                self = .sequenced(first: baseGesture, second: secondGesture)
                return

            case "simultaneously":
                guard let withArg = functionCall.argument(named: "with"),
                      let secondGesture = ParsedGesture.BaseGesture(syntax: withArg.expression) else {
                    return nil
                }
                self = .simultaneous(first: baseGesture, second: secondGesture)
                return

            case "exclusively":
                guard let beforeArg = functionCall.argument(named: "before"),
                      let secondGesture = ParsedGesture.BaseGesture(syntax: beforeArg.expression) else {
                    return nil
                }
                self = .exclusive(first: baseGesture, second: secondGesture)
                return

            default:
                return nil
            }
        }

        // Simple gesture: DragGesture(), TapGesture(count: 2), etc.
        guard let calledExpr = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) else {
            return nil
        }

        switch calledExpr.baseName.text {
        case "DragGesture":
            let minimumDistance = functionCall.argument(named: "minimumDistance")
                .flatMap({ CGFloat(syntax: $0.expression) }) ?? 10
            let coordinateSpace = functionCall.argument(named: "coordinateSpace")
                .flatMap({ ParsedCoordinateSpace(syntax: $0.expression) }) ?? .local
            self = .drag(minimumDistance: minimumDistance, coordinateSpace: coordinateSpace)

        case "MagnificationGesture", "MagnifyGesture":
            let delta = functionCall.argument(named: "minimumScaleDelta")
                .flatMap({ CGFloat(syntax: $0.expression) }) ?? 0.01
            self = .magnification(minimumScaleDelta: delta)

        case "RotationGesture", "RotateGesture":
            let delta = functionCall.argument(named: "minimumAngleDelta")
                .flatMap({ Angle(syntax: $0.expression) }) ?? .degrees(1)
            self = .rotation(minimumAngleDelta: delta)

        case "LongPressGesture":
            let duration = functionCall.argument(named: "minimumDuration")
                .flatMap({ Double(syntax: $0.expression) }) ?? 0.5
            let maxDistance = functionCall.argument(named: "maximumDistance")
                .flatMap({ CGFloat(syntax: $0.expression) }) ?? 10
            self = .longPress(minimumDuration: duration, maximumDistance: maxDistance)

        case "TapGesture":
            let count = functionCall.argument(named: "count")
                .flatMap({ Int(syntax: $0.expression) }) ?? 1
            self = .tap(count: count)

        default:
            return nil
        }
    }
}

// MARK: - AnyGesture Creation

extension ParsedGesture {
    /// Creates an `AnyGesture<Void>` from this parsed gesture.
    /// The gesture has callbacks attached that dispatch events to JavaScript.
    @MainActor
    public func makeGesture(node: Node, runtime: LightpandaRuntime) -> AnyGesture<Void> {
        makeGestureFromBase(base, node: node, runtime: runtime)
    }

    @MainActor
    private func makeGestureFromBase(_ base: BaseGesture, node: Node, runtime: LightpandaRuntime) -> AnyGesture<Void> {
        switch base {
        case .drag(let minimumDistance, _):
            return AnyGesture(
                DragGesture(minimumDistance: minimumDistance)
                    .onChanged { value in
                        dispatchEvent(onChanged ?? "drag", node: node, runtime: runtime, detail: [
                            "location": ["x": value.location.x, "y": value.location.y],
                            "startLocation": ["x": value.startLocation.x, "y": value.startLocation.y],
                            "translation": ["width": value.translation.width, "height": value.translation.height],
                            "velocity": ["width": value.velocity.width, "height": value.velocity.height]
                        ])
                    }
                    .onEnded { value in
                        dispatchEvent(onEnded ?? "dragEnd", node: node, runtime: runtime, detail: [
                            "location": ["x": value.location.x, "y": value.location.y],
                            "startLocation": ["x": value.startLocation.x, "y": value.startLocation.y],
                            "translation": ["width": value.translation.width, "height": value.translation.height],
                            "velocity": ["width": value.velocity.width, "height": value.velocity.height]
                        ])
                    }
                    .map { _ in () }
            )

        case .magnification(let minimumScaleDelta):
            return AnyGesture(
                MagnificationGesture(minimumScaleDelta: minimumScaleDelta)
                    .onChanged { value in
                        dispatchEvent(onChanged ?? "magnify", node: node, runtime: runtime, detail: ["magnification": value])
                    }
                    .onEnded { value in
                        dispatchEvent(onEnded ?? "magnifyEnd", node: node, runtime: runtime, detail: ["magnification": value])
                    }
                    .map { _ in () }
            )

        case .rotation(let minimumAngleDelta):
            return AnyGesture(
                RotationGesture(minimumAngleDelta: minimumAngleDelta)
                    .onChanged { value in
                        dispatchEvent(onChanged ?? "rotate", node: node, runtime: runtime, detail: ["rotation": value.degrees])
                    }
                    .onEnded { value in
                        dispatchEvent(onEnded ?? "rotateEnd", node: node, runtime: runtime, detail: ["rotation": value.degrees])
                    }
                    .map { _ in () }
            )

        case .longPress(let minimumDuration, let maximumDistance):
            return AnyGesture(
                LongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
                    .onEnded { _ in
                        dispatchEvent(onEnded ?? "longPress", node: node, runtime: runtime, detail: ["minimumDuration": minimumDuration])
                    }
                    .map { _ in () }
            )

        case .tap(let count):
            return AnyGesture(
                TapGesture(count: count)
                    .onEnded {
                        dispatchEvent(onEnded ?? "tap", node: node, runtime: runtime, detail: ["count": count])
                    }
                    .map { _ in () }
            )

        case .sequenced(let first, let second):
            return makeSequencedGesture(first: first, second: second, node: node, runtime: runtime)

        case .simultaneous(let first, let second):
            return makeSimultaneousGesture(first: first, second: second, node: node, runtime: runtime)

        case .exclusive(let first, let second):
            return makeExclusiveGesture(first: first, second: second, node: node, runtime: runtime)
        }
    }

    // MARK: - Composed Gestures

    @MainActor
    private func makeSequencedGesture(first: BaseGesture, second: BaseGesture, node: Node, runtime: LightpandaRuntime) -> AnyGesture<Void> {
        // LongPress -> Drag is the most common
        if case .longPress(let duration, let maxDistance) = first,
           case .drag(let minDistance, _) = second {
            return AnyGesture(
                LongPressGesture(minimumDuration: duration, maximumDistance: maxDistance)
                    .sequenced(before: DragGesture(minimumDistance: minDistance))
                    .onChanged { value in
                        switch value {
                        case .first(true):
                            dispatchEvent(onChanged ?? "sequencedGesture", node: node, runtime: runtime, detail: ["phase": "longPress", "completed": true])
                        case .second(true, let drag):
                            if let drag = drag {
                                dispatchEvent(onChanged ?? "sequencedGesture", node: node, runtime: runtime, detail: [
                                    "phase": "drag",
                                    "location": ["x": drag.location.x, "y": drag.location.y],
                                    "translation": ["width": drag.translation.width, "height": drag.translation.height]
                                ])
                            }
                        default:
                            break
                        }
                    }
                    .onEnded { value in
                        if case .second(true, let drag) = value, let drag = drag {
                            dispatchEvent(onEnded ?? "sequencedGestureEnd", node: node, runtime: runtime, detail: [
                                "first": ["type": "longPress", "completed": true],
                                "second": [
                                    "type": "drag",
                                    "location": ["x": drag.location.x, "y": drag.location.y],
                                    "translation": ["width": drag.translation.width, "height": drag.translation.height]
                                ]
                            ])
                        }
                    }
                    .map { _ in () }
            )
        }

        // Tap -> Drag
        if case .tap(let count) = first,
           case .drag(let minDistance, _) = second {
            return AnyGesture(
                TapGesture(count: count)
                    .sequenced(before: DragGesture(minimumDistance: minDistance))
                    .onEnded { value in
                        if case .second((), let drag) = value, let drag = drag {
                            dispatchEvent(onEnded ?? "sequencedGestureEnd", node: node, runtime: runtime, detail: [
                                "first": ["type": "tap", "count": count],
                                "second": [
                                    "type": "drag",
                                    "location": ["x": drag.location.x, "y": drag.location.y],
                                    "translation": ["width": drag.translation.width, "height": drag.translation.height]
                                ]
                            ])
                        }
                    }
                    .map { _ in () }
            )
        }

        // Fallback: just use first gesture
        return makeGestureFromBase(first, node: node, runtime: runtime)
    }

    @MainActor
    private func makeSimultaneousGesture(first: BaseGesture, second: BaseGesture, node: Node, runtime: LightpandaRuntime) -> AnyGesture<Void> {
        // Magnification + Rotation
        if case .magnification(let scaleDelta) = first,
           case .rotation(let angleDelta) = second {
            return AnyGesture(
                MagnificationGesture(minimumScaleDelta: scaleDelta)
                    .simultaneously(with: RotationGesture(minimumAngleDelta: angleDelta))
                    .onChanged { value in
                        var detail: [String: Any] = [:]
                        if let mag = value.first { detail["magnification"] = mag }
                        if let rot = value.second { detail["rotation"] = rot.degrees }
                        dispatchEvent(onChanged ?? "simultaneousGesture", node: node, runtime: runtime, detail: detail)
                    }
                    .onEnded { value in
                        var detail: [String: Any] = [:]
                        if let mag = value.first { detail["magnification"] = mag }
                        if let rot = value.second { detail["rotation"] = rot.degrees }
                        dispatchEvent(onEnded ?? "simultaneousGestureEnd", node: node, runtime: runtime, detail: detail)
                    }
                    .map { _ in () }
            )
        }

        // Rotation + Magnification
        if case .rotation(let angleDelta) = first,
           case .magnification(let scaleDelta) = second {
            return AnyGesture(
                RotationGesture(minimumAngleDelta: angleDelta)
                    .simultaneously(with: MagnificationGesture(minimumScaleDelta: scaleDelta))
                    .onChanged { value in
                        var detail: [String: Any] = [:]
                        if let rot = value.first { detail["rotation"] = rot.degrees }
                        if let mag = value.second { detail["magnification"] = mag }
                        dispatchEvent(onChanged ?? "simultaneousGesture", node: node, runtime: runtime, detail: detail)
                    }
                    .onEnded { value in
                        var detail: [String: Any] = [:]
                        if let rot = value.first { detail["rotation"] = rot.degrees }
                        if let mag = value.second { detail["magnification"] = mag }
                        dispatchEvent(onEnded ?? "simultaneousGestureEnd", node: node, runtime: runtime, detail: detail)
                    }
                    .map { _ in () }
            )
        }

        // Drag + Rotation
        if case .drag(let minDistance, _) = first,
           case .rotation(let angleDelta) = second {
            return AnyGesture(
                DragGesture(minimumDistance: minDistance)
                    .simultaneously(with: RotationGesture(minimumAngleDelta: angleDelta))
                    .onChanged { value in
                        var detail: [String: Any] = [:]
                        if let drag = value.first {
                            detail["location"] = ["x": drag.location.x, "y": drag.location.y]
                            detail["translation"] = ["width": drag.translation.width, "height": drag.translation.height]
                        }
                        if let rot = value.second { detail["rotation"] = rot.degrees }
                        dispatchEvent(onChanged ?? "simultaneousGesture", node: node, runtime: runtime, detail: detail)
                    }
                    .onEnded { value in
                        var detail: [String: Any] = [:]
                        if let drag = value.first {
                            detail["location"] = ["x": drag.location.x, "y": drag.location.y]
                            detail["translation"] = ["width": drag.translation.width, "height": drag.translation.height]
                        }
                        if let rot = value.second { detail["rotation"] = rot.degrees }
                        dispatchEvent(onEnded ?? "simultaneousGestureEnd", node: node, runtime: runtime, detail: detail)
                    }
                    .map { _ in () }
            )
        }

        // Drag + Magnification
        if case .drag(let minDistance, _) = first,
           case .magnification(let scaleDelta) = second {
            return AnyGesture(
                DragGesture(minimumDistance: minDistance)
                    .simultaneously(with: MagnificationGesture(minimumScaleDelta: scaleDelta))
                    .onChanged { value in
                        var detail: [String: Any] = [:]
                        if let drag = value.first {
                            detail["location"] = ["x": drag.location.x, "y": drag.location.y]
                            detail["translation"] = ["width": drag.translation.width, "height": drag.translation.height]
                        }
                        if let mag = value.second { detail["magnification"] = mag }
                        dispatchEvent(onChanged ?? "simultaneousGesture", node: node, runtime: runtime, detail: detail)
                    }
                    .onEnded { value in
                        var detail: [String: Any] = [:]
                        if let drag = value.first {
                            detail["location"] = ["x": drag.location.x, "y": drag.location.y]
                            detail["translation"] = ["width": drag.translation.width, "height": drag.translation.height]
                        }
                        if let mag = value.second { detail["magnification"] = mag }
                        dispatchEvent(onEnded ?? "simultaneousGestureEnd", node: node, runtime: runtime, detail: detail)
                    }
                    .map { _ in () }
            )
        }

        // Fallback
        return makeGestureFromBase(first, node: node, runtime: runtime)
    }

    @MainActor
    private func makeExclusiveGesture(first: BaseGesture, second: BaseGesture, node: Node, runtime: LightpandaRuntime) -> AnyGesture<Void> {
        // Tap vs LongPress
        if case .tap(let count) = first,
           case .longPress(let duration, let maxDistance) = second {
            return AnyGesture(
                TapGesture(count: count)
                    .exclusively(before: LongPressGesture(minimumDuration: duration, maximumDistance: maxDistance))
                    .onEnded { value in
                        switch value {
                        case .first:
                            dispatchEvent(onEnded ?? "exclusiveGesture", node: node, runtime: runtime, detail: ["gesture": "tap", "count": count])
                        case .second:
                            dispatchEvent(onEnded ?? "exclusiveGesture", node: node, runtime: runtime, detail: ["gesture": "longPress", "duration": duration])
                        }
                    }
                    .map { _ in () }
            )
        }

        // LongPress vs Tap
        if case .longPress(let duration, let maxDistance) = first,
           case .tap(let count) = second {
            return AnyGesture(
                LongPressGesture(minimumDuration: duration, maximumDistance: maxDistance)
                    .exclusively(before: TapGesture(count: count))
                    .onEnded { value in
                        switch value {
                        case .first:
                            dispatchEvent(onEnded ?? "exclusiveGesture", node: node, runtime: runtime, detail: ["gesture": "longPress", "duration": duration])
                        case .second:
                            dispatchEvent(onEnded ?? "exclusiveGesture", node: node, runtime: runtime, detail: ["gesture": "tap", "count": count])
                        }
                    }
                    .map { _ in () }
            )
        }

        // Fallback
        return makeGestureFromBase(first, node: node, runtime: runtime)
    }

    // MARK: - Event Dispatch

    @MainActor
    private func dispatchEvent(_ eventName: String, node: Node, runtime: LightpandaRuntime, detail: [String: Any]) {
        let detailJSON = (try? JSONSerialization.data(withJSONObject: detail))
            .flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
        Task {
            try? await node.callFunction(
                runtime: runtime,
                function: #"""
                function() {
                    this.dispatchEvent(new CustomEvent("\#(eventName)", {
                        bubbles: true,
                        detail: \#(detailJSON)
                    }));
                }
                """#
            )
        }
    }
}
