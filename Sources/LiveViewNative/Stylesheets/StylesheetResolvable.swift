import Foundation
import LiveViewNativeStylesheet
import LiveViewNativeCore

@MainActor
public protocol StylesheetResolvable {
    associatedtype Resolved
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved
}

public enum StylesheetResolvableSet<T>: @preconcurrency Decodable, StylesheetResolvable where T: Decodable & StylesheetResolvable, T.Resolved: Hashable {
    public typealias Resolved = Set<T.Resolved>
    
    case constant(Set<T.Resolved>)
    case resolvable([T])
    
    public init(from decoder: any Decoder) throws {
        self = .resolvable(try decoder.singleValueContainer().decode([T].self))
    }
    
    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Set<T.Resolved> {
        switch self {
        case let .constant(value):
            return value
        case let .resolvable(value):
            return Set(value.map({ $0.resolve(on: element, in: context) }))
        }
    }
}

extension StylesheetResolvableSet: @preconcurrency AttributeDecodable {
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.badValue(Self.self) }
        self = .resolvable(try makeJSONDecoder().decode([T].self, from: Data(value.utf8)))
    }
}

extension Array: StylesheetResolvable where Element: StylesheetResolvable {
    public typealias Resolved = [Element.Resolved]
    
    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved {
        self.map({ $0.resolve(on: element, in: context) })
    }
}

extension Optional: StylesheetResolvable where Wrapped: StylesheetResolvable {
    public typealias Resolved = Optional<Wrapped.Resolved>
    
    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Resolved {
        switch self {
        case .none:
            return .none
        case .some(let wrapped):
            return .some(wrapped.resolve(on: element, in: context))
        }
    }
}
