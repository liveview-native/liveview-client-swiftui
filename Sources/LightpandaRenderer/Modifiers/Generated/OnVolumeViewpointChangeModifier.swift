#if os(visionOS)
import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for responding to changes in the viewpoint of a volume.
/// The action dispatches a custom event on the element with oldValue and newValue in the detail.
///
/// Usage:
/// ```html
/// <!-- Dispatches "volumeViewpointChange" event (default) -->
/// <vstack modifiers="onVolumeViewpointChange()">
///   ...
/// </vstack>
///
/// <!-- Dispatches "viewpointChanged" event -->
/// <vstack modifiers="onVolumeViewpointChange(viewpointChanged)">
///   ...
/// </vstack>
///
/// <!-- With options -->
/// <vstack modifiers="onVolumeViewpointChange(updateStrategy: .supported, initial: true, viewpointChanged)">
///   ...
/// </vstack>
/// ```
///
/// JavaScript:
/// ```javascript
/// element.addEventListener("volumeViewpointChange", (e) => {
///     console.log("Viewpoint changed:", e.detail);
/// });
/// ```
@available(visionOS 2.0, *)
@MainActor
public enum OnVolumeViewpointChangeModifier<Library: ElementLibrary>: @unchecked Sendable {
    case onVolumeViewpointChange(updateStrategy: VolumeViewpointUpdateStrategy, initial: Bool, action: String)
}

@available(visionOS 2.0, *)
extension OnVolumeViewpointChangeModifier: RuntimeViewModifier {
    public static var baseName: String { "onVolumeViewpointChange" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let updateStrategy: VolumeViewpointUpdateStrategy = syntax.argument(named: "updateStrategy").flatMap({ VolumeViewpointUpdateStrategy(syntax: $0.expression) }) ?? .supported
        let initial: Bool = syntax.argument(named: "initial").flatMap({ Bool(syntax: $0.expression) }) ?? true

        // The action name can be:
        // 1. A named argument: onVolumeViewpointChange(action: myAction)
        // 2. A trailing unlabeled argument: onVolumeViewpointChange(updateStrategy: .supported, initial: true, myAction)
        // 3. Default if not provided: "volumeViewpointChange"
        let action: String
        if let namedAction = syntax.argument(named: "action").flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) {
            action = namedAction
        } else if let lastArg = syntax.arguments.last,
                  lastArg.label == nil,
                  let actionName = lastArg.expression.as(DeclReferenceExprSyntax.self)?.baseName.text {
            action = actionName
        } else {
            action = "volumeViewpointChange"
        }

        self = .onVolumeViewpointChange(updateStrategy: updateStrategy, initial: initial, action: action)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .onVolumeViewpointChange(let updateStrategy, let initial, let action):
            OnVolumeViewpointChangeModifierBody(updateStrategy: updateStrategy, initial: initial, eventName: action, content: _content)
        }
    }
}

/// Helper view that dispatches a custom event when the volume viewpoint changes
@available(visionOS 2.0, *)
private struct OnVolumeViewpointChangeModifierBody<Content: View>: View {
    let updateStrategy: VolumeViewpointUpdateStrategy
    let initial: Bool
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onVolumeViewpointChange(updateStrategy: updateStrategy, initial: initial) { oldValue, newValue in
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {
                                oldValue: {
                                    position: { x: \#(oldValue.position.x), y: \#(oldValue.position.y), z: \#(oldValue.position.z) },
                                    rotation: { angle: \#(oldValue.rotation.angle.radians), axis: { x: \#(oldValue.rotation.axis.x), y: \#(oldValue.rotation.axis.y), z: \#(oldValue.rotation.axis.z) } }
                                },
                                newValue: {
                                    position: { x: \#(newValue.position.x), y: \#(newValue.position.y), z: \#(newValue.position.z) },
                                    rotation: { angle: \#(newValue.rotation.angle.radians), axis: { x: \#(newValue.rotation.axis.x), y: \#(newValue.rotation.axis.y), z: \#(newValue.rotation.axis.z) } }
                                }
                            }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
#endif
