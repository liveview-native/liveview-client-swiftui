import SwiftUI
import SwiftSyntax

/// Modifier for configuring VoiceOver to queue announcements.
///
/// Usage:
/// ```html
/// <text modifiers="speechAnnouncementsQueued()">Queued</text>
/// <text modifiers="speechAnnouncementsQueued(true)">Queued</text>
/// <text modifiers="speechAnnouncementsQueued(false)">Not Queued</text>
/// ```
public enum SpeechAnnouncementsQueuedModifier<Library: ElementLibrary>: @unchecked Sendable {
    case speechAnnouncementsQueued(Bool)
}

extension SpeechAnnouncementsQueuedModifier: RuntimeViewModifier {
    public static var baseName: String { "speechAnnouncementsQueued" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let value = syntax.arguments.first.flatMap({ Bool(syntax: $0.expression) }) ?? true
        self = .speechAnnouncementsQueued(value)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .speechAnnouncementsQueued(let value):
            _content.speechAnnouncementsQueued(value)
        }
    }
}
