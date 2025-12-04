import SwiftUI
import SwiftSyntax
import LightpandaClient

public struct ViewReference<Library: ElementLibrary>: View, @preconcurrency SyntaxConvertible {
    @Environment(Node.self) private var node
    
    let reference: String?
    
    public init(reference: String?) {
        self.reference = reference
    }
    
    public init?(syntax: some SyntaxProtocol) {
        self.reference = syntax.as(DeclReferenceExprSyntax.self)?.baseName.text
    }
    
    public var body: some View {
        if let reference {
            node.children(in: reference, default: false, library: Library.self)
        }
    }
}
