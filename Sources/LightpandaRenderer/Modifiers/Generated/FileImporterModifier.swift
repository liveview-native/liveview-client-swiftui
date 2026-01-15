import SwiftUI
import SwiftSyntax
import UniformTypeIdentifiers
import LightpandaClient

/// Modifier for presenting a system file import interface.
///
/// Supported variants:
/// - `fileImporter(isPresented: $showPicker, allowedContentTypes: [.pdf, .image], onCompletion: fileSelected)`
/// - `fileImporter(isPresented: $showPicker, allowedContentTypes: [.pdf], allowsMultipleSelection: true, onCompletion: filesSelected)`
///
/// ## Usage
/// ```html
/// <vstack modifiers='fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.pdf, .image], onCompletion: fileSelected)'>
///     <button>
///         <text template="label">Select File</text>
///     </button>
/// </vstack>
/// ```
///
/// ## Event Handling
/// The `onCompletion` parameter specifies the event name dispatched when a file is selected or an error occurs.
///
/// ### Success Event
/// ```javascript
/// element.addEventListener("fileSelected", (event) => {
///     // Single file selection
///     console.log("Selected file URL:", event.detail.url);
///     // Multiple file selection (when allowsMultipleSelection: true)
///     console.log("Selected file URLs:", event.detail.urls);
/// });
/// ```
///
/// ### Cancellation
/// When the user cancels, the `isPresentedChanged` event is dispatched with `value: false`.
///
/// ## Binding Changes
/// The `$showFilePicker` binding dispatches a `showFilePickerChanged` event when toggled:
/// ```javascript
/// element.addEventListener("showFilePickerChanged", (event) => {
///     console.log("File picker visibility:", event.detail.value);
/// });
/// ```
@MainActor
public enum FileImporterModifier<Library: ElementLibrary>: @unchecked Sendable {
    /// fileImporter(isPresented: $binding, allowedContentTypes: [...], onCompletion: eventName)
    case singleSelection(
        isPresented: NodeBinding<Bool>,
        allowedContentTypes: [UTType],
        onCompletion: String
    )

    /// fileImporter(isPresented: $binding, allowedContentTypes: [...], allowsMultipleSelection: Bool, onCompletion: eventName)
    case multipleSelection(
        isPresented: NodeBinding<Bool>,
        allowedContentTypes: [UTType],
        allowsMultipleSelection: Bool,
        onCompletion: String
    )
}

extension FileImporterModifier: RuntimeViewModifier {
    public static var baseName: String { "fileImporter" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []

        // Try to parse: fileImporter(isPresented: $binding, allowedContentTypes: [...], allowsMultipleSelection: Bool, onCompletion: eventName)
        do {
            guard let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "FileImporterModifier", argument: "isPresented")
            }
            guard let allowedContentTypes = syntax.argument(named: "allowedContentTypes").flatMap({ [UTType](syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "FileImporterModifier", argument: "allowedContentTypes")
            }
            guard let allowsMultipleSelection = syntax.argument(named: "allowsMultipleSelection").flatMap({ Bool(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "FileImporterModifier", argument: "allowsMultipleSelection")
            }
            let onCompletion = syntax.argument(named: "onCompletion")
                .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "fileImportCompleted"

            self = .multipleSelection(
                isPresented: isPresented,
                allowedContentTypes: allowedContentTypes,
                allowsMultipleSelection: allowsMultipleSelection,
                onCompletion: onCompletion
            )
            return
        } catch {
            errors.append(error)
        }

        // Try to parse: fileImporter(isPresented: $binding, allowedContentTypes: [...], onCompletion: eventName)
        do {
            guard let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "FileImporterModifier", argument: "isPresented")
            }
            guard let allowedContentTypes = syntax.argument(named: "allowedContentTypes").flatMap({ [UTType](syntax: $0.expression) }) else {
                throw ModifierParseError.missingRequiredArgument(modifier: "FileImporterModifier", argument: "allowedContentTypes")
            }
            let onCompletion = syntax.argument(named: "onCompletion")
                .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "fileImportCompleted"

            self = .singleSelection(
                isPresented: isPresented,
                allowedContentTypes: allowedContentTypes,
                onCompletion: onCompletion
            )
            return
        } catch {
            errors.append(error)
        }

        throw ModifierParseError.noMatchingVariant(modifier: "FileImporterModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        FileImporterModifierBody<Library>(modifier: self, content: _content)
    }
}

/// Internal view that resolves NodeBinding to Binding at runtime using environment.
private struct FileImporterModifierBody<Library: ElementLibrary>: View {
    let modifier: FileImporterModifier<Library>
    let content: FileImporterModifier<Library>.Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        switch modifier {
        case .singleSelection(let isPresented, let allowedContentTypes, let onCompletion):
            content.fileImporter(
                isPresented: isPresented.binding(node: node, runtime: runtime),
                allowedContentTypes: allowedContentTypes
            ) { result in
                dispatchCompletionEvent(result: result.map { [$0] }, eventName: onCompletion, isSingleSelection: true)
            }

        case .multipleSelection(let isPresented, let allowedContentTypes, let allowsMultipleSelection, let onCompletion):
            content.fileImporter(
                isPresented: isPresented.binding(node: node, runtime: runtime),
                allowedContentTypes: allowedContentTypes,
                allowsMultipleSelection: allowsMultipleSelection
            ) { result in
                dispatchCompletionEvent(result: result, eventName: onCompletion, isSingleSelection: !allowsMultipleSelection)
            }
        }
    }

    private func dispatchCompletionEvent(result: Result<[URL], Error>, eventName: String, isSingleSelection: Bool) {
        Task {
            switch result {
            case .success(let urls):
                let urlStrings = urls.map { $0.absoluteString }
                let urlsJSON = String(data: try! JSONEncoder().encode(urlStrings), encoding: .utf8)!

                if isSingleSelection, let firstURL = urlStrings.first {
                    let urlJSON = String(data: try! JSONEncoder().encode(firstURL), encoding: .utf8)!
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.dispatchEvent(new CustomEvent("\#(eventName)", {
                                bubbles: true,
                                detail: { success: true, url: \#(urlJSON), urls: \#(urlsJSON) }
                            }));
                        }
                        """#
                    )
                } else {
                    try? await node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            this.dispatchEvent(new CustomEvent("\#(eventName)", {
                                bubbles: true,
                                detail: { success: true, urls: \#(urlsJSON) }
                            }));
                        }
                        """#
                    )
                }

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
