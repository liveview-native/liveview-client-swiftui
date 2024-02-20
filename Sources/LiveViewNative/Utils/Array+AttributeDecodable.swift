//
//  Array+AttributeDecodable.swift
//
//
//  Created by Carson Katri on 2/20/24.
//

import Foundation
import LiveViewNativeCore

extension Array: AttributeDecodable where Element: Decodable & AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = try JSONDecoder().decode(Self.self, from: Data(value.utf8))
    }
}
