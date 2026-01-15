import SwiftUI
import SwiftSyntax
import LightpandaClient

/// Modifier for presenting a system file move interface.
///
/// Supported variants:
/// - `fileMover(isPresented: $showMover, file: URL(string: "..."), onCompletion: fileMoved)`
///
/// ## Usage
/// ```html
/// <vstack modifiers='fileMover(isPresented: $showFileMover, file: URL(string: "file:///path/to/file.txt"), onCompletion: fileMoved)'>
///     <button>
///         <text template="label">Move File</text>
///     </button>
/// </vstack>
/// ```
///
/// ## Event Handling
/// The `onCompletion` parameter specifies the event name dispatched when the file is moved or an error occurs.
///
/// ### Success Event
/// ```javascript
/// element.addEventListener("fileMoved", (event) => {
///     console.log("New file URL:", event.detail.url);
/// });
/// ```
///
/// ### Error Event
/// ```javascript
/// element.addEventListener("fileMoved", (event) => {
///     if (!event.detail.success) {
///         console.error("Error:", event.detail.error);
///     }
/// });
/// ```
///
/// ## Binding Changes
/// The `$showFileMover` binding dispatches a `showFileMoverChanged` event when toggled:
/// ```javascript
/// element.addEventListener("showFileMoverChanged", (event) => {
///     console.log("File mover visibility:", event.detail.value);
/// });
/// ```
@MainActor
public enum FileMoverModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// fileMover(isPresented: $binding, file: URL?, onCompletion: eventName)
    case fileMover(
        isPresented: NodeBinding<Bool>,
        file: URL?,
        onCompletion: String
    )
}

extension FileMoverModifier: RuntimeViewModifier {
    public static var baseName: String { "fileMover" }

    public init(syntax: FunctionCallExprSyntax) throws {
        // Try to parse: fileMover(isPresented: $binding, file: URL?, onCompletion: eventName)
        guard let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) else {
            throw ModifierParseError.missingRequiredArgument(modifier: "FileMoverModifier", argument: "isPresented")
        }

        let file: URL? = syntax.argument(named: "file").flatMap({ URL(syntax: $0.expression) })

        let onCompletion = syntax.argument(named: "onCompletion")
            .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "fileMoveCompleted"

        self = .fileMover(
            isPresented: isPresented,
            file: file,
            onCompletion: onCompletion
        )
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        FileMoverModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
private struct FileMoverModifierBody<Library: ElementLibrary>: View {
    let modifier: FileMoverModifier<Library>
    let content: FileMoverModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .fileMover(let isPresented, let file, let onCompletion):
            content.fileMover(
                isPresented: isPresented.binding(node: node, runtime: runtime),
                file: file
            ) { result in
                dispatchCompletionEvent(result: result, eventName: onCompletion)
            }
        }
    }

    private func dispatchCompletionEvent(result: Result<URL, Error>, eventName: String) {
        Task {
            switch result {
            case .success(let url):
                let urlString = url.absoluteString
                let urlJSON = String(data: try! JSONEncoder().encode(urlString), encoding: .utf8)!

                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { success: true, url: \#(urlJSON) }
                        }));
                    }
                    """#
                )

            case .failure(let error):
                let errorMessage = String(data: try! JSONEncoder().encode(error.localizedDescription), encoding: .utf8)!
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: { success: false, error: \#(errorMessage) }
                        }));
                    }
                    """#
                )
            }
        }
    }
}
