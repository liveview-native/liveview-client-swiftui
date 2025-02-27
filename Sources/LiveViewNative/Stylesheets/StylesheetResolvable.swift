import Foundation
import LiveViewNativeStylesheet
import LiveViewNativeCore

@MainActor
protocol StylesheetResolvable {
    associatedtype Resolved
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved
}

enum StylesheetResolvableSet<T>: @preconcurrency Decodable, StylesheetResolvable where T: Decodable & StylesheetResolvable, T.Resolved: Hashable {
    typealias Resolved = Set<T.Resolved>
    
    case constant(Set<T.Resolved>)
    case resolvable([T])
    
    init(from decoder: any Decoder) throws {
        self = .resolvable(try decoder.singleValueContainer().decode([T].self))
    }
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Set<T.Resolved> {
        switch self {
        case let .constant(value):
            return value
        case let .resolvable(value):
            return Set(value.map({ $0.resolve(on: element, in: context) }))
        }
    }
}

extension StylesheetResolvableSet: @preconcurrency AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.badValue(Self.self) }
        self = .resolvable(try makeJSONDecoder().decode([T].self, from: Data(value.utf8)))
    }
}

extension Array: StylesheetResolvable where Element: StylesheetResolvable {
    typealias Resolved = [Element.Resolved]
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved {
        self.map({ $0.resolve(on: element, in: context) })
    }
}

extension Optional: StylesheetResolvable where Wrapped: StylesheetResolvable {
    typealias Resolved = Optional<Wrapped.Resolved>
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved {
        switch self {
        case .none:
            return .none
        case .some(let wrapped):
            return .some(wrapped.resolve(on: element, in: context))
        }
    }
}
