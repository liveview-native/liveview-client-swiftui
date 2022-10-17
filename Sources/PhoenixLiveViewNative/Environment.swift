//
//  Environment.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI

private struct FormModelKey: EnvironmentKey {
    static let defaultValue: FormModel? = nil
}

private struct ElementKey: EnvironmentKey {
    static let defaultValue: ElementNode? = nil
}

private struct TextFieldPrimaryActionKey: EnvironmentKey {
    public static var defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    /// The model for the nearest ancestor `<form>` element (or `nil`, if there is no such element).
    public var formModel: FormModel? {
        get { self[FormModelKey.self] }
        set { self[FormModelKey.self] = newValue }
    }
    
    /// The DOM element that the view was constructed from.
    public var element: ElementNode? {
        get { self[ElementKey.self] }
        set { self[ElementKey.self] = newValue }
    }
    
    @_spi(NarwinChat) public var textFieldPrimaryAction: (() -> Void)? {
        get { self[TextFieldPrimaryActionKey.self] }
        set { self[TextFieldPrimaryActionKey.self] = newValue }
    }
}
