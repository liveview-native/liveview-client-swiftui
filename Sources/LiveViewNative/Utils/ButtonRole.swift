//
//  ButtonRole.swift
//
//
//  Created by Carson Katri on 2/29/24.
//

import SwiftUI
import LiveViewNativeCore

/// The semantic role of a ``Button``.
///
/// Possible values:
/// * `destructive`
/// * `cancel`
extension ButtonRole: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        switch value {
        case "destructive":
            self = .destructive
        case "cancel":
            self = .cancel
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
