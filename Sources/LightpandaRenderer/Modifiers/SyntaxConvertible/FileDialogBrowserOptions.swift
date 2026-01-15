import SwiftUI
import SwiftSyntax

#if os(macOS)
extension FileDialogBrowserOptions: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let memberAccess = syntax.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let name = memberAccess.declName.baseName.text

        switch name {
        case "enumeratePackages": self = .enumeratePackages
        case "includeHiddenFiles": self = .includeHiddenFiles
        case "displayFileExtensions": self = .displayFileExtensions
        default: return nil
        }
    }
}
#endif
