//
//  ViewRegistry.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/11/22.
//

import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet

/// This protocol provides access to the `ViewModifier` type returned from `decodeModifier` in the `BuiltinRegistry`.
/// That type is used by `ModifierContainer.builtin`.
protocol BuiltinRegistryProtocol {
    associatedtype BuiltinModifier: ViewModifier & ParseableModifierValue
}

struct BuiltinRegistry<R: RootRegistry>: BuiltinRegistryProtocol {
    static func lookup(_ name: String, _ element: ElementNode) -> some View {
        return BuiltinElement<R>(name: name, element: element)
    }
}
