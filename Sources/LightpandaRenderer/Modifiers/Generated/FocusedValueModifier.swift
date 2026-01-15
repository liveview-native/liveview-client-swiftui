import SwiftUI
import SwiftSyntax

// MARK: - FocusedValueModifier (NOT SUPPORTED)
//
// The `focusedValue(_:_:)` modifier CANNOT be supported in LightpandaRenderer because it requires
// compile-time type information that cannot be parsed at runtime:
//
// 1. `FocusedValueKey` protocol conformance must be defined at compile time
// 2. `FocusedValues` must be extended with a computed property at compile time
// 3. `WritableKeyPath<FocusedValues, Value?>` references that compile-time property
//
// Example of what would be needed (compile-time only):
// ```swift
// struct MyFocusedKey: FocusedValueKey {
//     typealias Value = String
// }
// extension FocusedValues {
//     var myValue: String? {
//         get { self[MyFocusedKey.self] }
//         set { self[MyFocusedKey.self] = newValue }
//     }
// }
// // Then use: .focusedValue(\.myValue, someString)
// ```
//
// Since we cannot:
// - Define new FocusedValueKey conformances at runtime
// - Extend FocusedValues at runtime
// - Create key paths to non-existent properties
//
// This modifier is fundamentally incompatible with runtime parsing.
//
// For focus-related functionality in LightpandaRenderer, use the `FocusedModifier` instead:
// - `focused($isFocused)` for boolean focus state
// - `focused($focusedField, equals: .fieldName)` for enum-style focus
//
// See: https://developer.apple.com/documentation/swiftui/focusedvaluekey