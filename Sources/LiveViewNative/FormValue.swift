//
//  FormValue.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/17/23.
//

import Foundation

/// A form value is any type that can be stored in a ``FormModel`` and used with ``FormState``.
///
/// This protocol defines the requirements for converting to/from the serialized form data representation.
/// There are two serialized formats: form value strings and the codable representation.
///
/// The form value string (``formValue`` and ``init(formValue:)``) mode is used for form values that are provided in a `value` attribute on form controls or are stored in `<phx-form>` elements.
///
/// The `Codable` mode is used when a live binding is used with a form control.
/// See ``FormState`` for more information about how form values and live bindings interact.
///
/// A number of out-of-the-box `FormValue` implementations are provided:
/// 1. `Optional`, when the `Wrapped` type itself conforms to `FormValue`
/// 2. `String`
/// 3. `Bool`
/// 4. `Double`
public protocol FormValue: Equatable, Codable {
    /// Converts the value from this type to the string representation.
    var formValue: String { get }
    
    /// Converts the value from the string representation to this type.
    init?(formValue: String)
}

extension FormValue {
    func isEqual<T>(to other: T) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
    
    func createNew(formValue: String) -> Self? {
        return Self(formValue: formValue)
    }
}

extension Optional: FormValue where Wrapped: FormValue {
    public var formValue: String {
        if let value = self {
            return value.formValue
        } else {
            return ""
        }
    }
    
    public init?(formValue: String) {
        self = Wrapped(formValue: formValue)
    }
}

extension String: FormValue {
    public var formValue: String { self }
    
    public init(formValue: String) {
        self = formValue
    }
}

extension Bool: FormValue {
    public var formValue: String {
        self.description
    }
    
    public init?(formValue: String) {
        guard let value = Bool(formValue)
        else { return nil }
        self = value
    }
}

extension Double: FormValue {
    public var formValue: String {
        self.formatted()
    }
    
    public init?(formValue: String) {
        guard let value = Double(formValue)
        else { return nil }
        self = value
    }
}
