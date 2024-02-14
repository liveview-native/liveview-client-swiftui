//
//  Selection.swift
//  
//
//  Created by Carson Katri on 2/21/23.
//

import Foundation
import LiveViewNativeCore

/// Selection of either a single value or set of values.
enum Selection: Codable, AttributeDecodable, Equatable {
    case none
    case single(String?)
    case multiple(Set<String>)
    
    var single: String? {
        get {
            guard case let .single(selection) = self else { return nil }
            return selection
        }
        set {
            self = .single(newValue)
        }
    }
    
    var multiple: Set<String> {
        get {
            guard case let .multiple(selection) = self else { return [] }
            return selection
        }
        set {
            self = .multiple(newValue)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .none
        } else if let item = try? container.decode(String.self) {
            self = .single(item)
        } else {
            self = .multiple(try container.decode(Set<String>.self))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .none:
            try container.encodeNil()
        case .single(let selection):
            try container.encode(selection)
        case .multiple(let selection):
            try container.encode(selection)
        }
    }
    
    init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        do {
            self = try JSONDecoder().decode(Self.self, from: Data(value.utf8))
        } catch {
            if value.isEmpty {
                self = .single(nil)
            } else {
                self = .single(value)
            }
        }
    }
}
