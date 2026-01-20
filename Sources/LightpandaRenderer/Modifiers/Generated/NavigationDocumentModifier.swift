import SwiftUI
import SwiftSyntax

/// Modifier for navigationDocument(_:).
/// Only the URL variant is supported since Transferable types cannot be created at runtime.
public enum NavigationDocumentModifier<Library: ElementLibrary>: @unchecked Sendable {
    #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
    case navigationDocument(Foundation.URL)
    #endif
}

extension NavigationDocumentModifier: RuntimeViewModifier {
    public static var baseName: String { "navigationDocument" }

    public init(syntax: FunctionCallExprSyntax) throws {
        var errors: [Error] = []
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            do {
                guard let url = (syntax.arguments.count > 0 ? syntax.arguments[syntax.arguments.startIndex] : nil).flatMap({ Foundation.URL(syntax: $0.expression) }) else {
                    throw ModifierParseError.missingRequiredArgument(modifier: "NavigationDocumentModifier", argument: "url")
                }
                self = .navigationDocument(url)
                return
            } catch {
                errors.append(error)
            }
        }
        #endif
        throw ModifierParseError.noMatchingVariant(modifier: "NavigationDocumentModifier", errors: errors)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
        case .navigationDocument(let url):
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                _content.navigationDocument(url)
            } else {
                _content
            }
        #endif
        }
    }
}
