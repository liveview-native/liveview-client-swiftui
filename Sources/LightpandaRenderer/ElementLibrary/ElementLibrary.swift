//
//  ElementLibrary.swift
//  LightpandaClient
//
//  Created by Carson Katri on 10/7/25.
//

import SwiftUI
import LightpandaClient

public protocol ElementLibrary {
    associatedtype TagName: RawRepresentable where TagName.RawValue == String
    
    associatedtype Body: View
    
    @MainActor
    @ViewBuilder
    static func render(_ tag: TagName, for node: Node) -> Body
}
