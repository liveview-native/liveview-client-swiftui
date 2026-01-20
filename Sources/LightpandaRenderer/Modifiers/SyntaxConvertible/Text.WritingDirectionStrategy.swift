#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
import SwiftUI
import SwiftSyntax

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
extension SwiftUICore.Text.WritingDirectionStrategy: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self)
        else { return nil }

        if memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "layoutBased":
                self = .layoutBased
            case "contentBased":
                self = .contentBased
            case "default":
                self = .default
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
#endif
