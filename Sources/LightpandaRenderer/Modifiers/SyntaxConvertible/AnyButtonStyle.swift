import SwiftUI
import SwiftSyntax

public struct AnyButtonStyle: PrimitiveButtonStyle, @preconcurrency SyntaxConvertible {
    let style: any ButtonStyle
    
    public init?(syntax: some SyntaxProtocol) {
        return nil
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        fatalError()
    }
}
