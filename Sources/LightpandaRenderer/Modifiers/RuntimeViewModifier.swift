import SwiftSyntax
import SwiftUI

public protocol RuntimeViewModifier: ViewModifier {
    static var baseName: String { get }
    
    init(syntax: FunctionCallExprSyntax) throws
}
