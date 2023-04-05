//
//  Edge.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

extension Edge: Decodable {
    public init(from decoder: Decoder) throws {
        switch try decoder.singleValueContainer().decode(String.self) {
        case "top": self = .top
        case "leading": self = .leading
        case "bottom": self = .bottom
        case "trailing": self = .trailing
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown edge '\(`default`)'"))
        }
    }
}
