import SwiftSyntax
import SwiftUI

public protocol RuntimeViewModifier<Library>: ViewModifier {
    static var baseName: String { get }
    
    init(syntax: FunctionCallExprSyntax) throws
    
    associatedtype Library: ElementLibrary
}
