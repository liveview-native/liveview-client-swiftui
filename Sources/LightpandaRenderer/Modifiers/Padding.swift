import SwiftUI
import SwiftSyntax

enum PaddingModifier: ViewModifier {
    case identity
    case edgeInsets(EdgeInsets)
    case edgesAndLength(Edge.Set, CGFloat?)
    case length(CGFloat)
    
    init?(arguments: LabeledExprListSyntax) {
        switch arguments.count {
        case 0:
            // .padding()
            self = .identity
            
        case 1:
            let firstArg = arguments.first!
            let expr = firstArg.expression.trimmedDescription
            
            // Check if it's an EdgeInsets
            if expr.contains("EdgeInsets") {
                // .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                if let insets = EdgeInsets(firstArg.expression) {
                    self = .edgeInsets(insets)
                } else {
                    return nil
                }
            } else if let length = CGFloat(firstArg.expression) {
                // .padding(16)
                self = .length(length)
            } else {
                return nil
            }
            
        case 2:
            // .padding(.horizontal, 20) or .padding(.all, nil)
            guard let edges = Edge.Set(arguments.first!.expression) else {
                return nil
            }
            
            let lengthArg = arguments.dropFirst().first!.expression
            let length = CGFloat(lengthArg)
            
            self = .edgesAndLength(edges, length)
            
        default:
            return nil
        }
    }
    
    func body(content: Content) -> some View {
        switch self {
        case .identity:
            content.padding()
        case .edgeInsets(let insets):
            content.padding(insets)
        case .edgesAndLength(let edges, let length):
            content.padding(edges, length)
        case .length(let length):
            content.padding(length)
        }
    }
}
