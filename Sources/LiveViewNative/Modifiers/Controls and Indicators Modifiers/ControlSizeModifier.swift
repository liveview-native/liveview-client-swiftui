//
//  ControlSizeModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/19/23.
//

import SwiftUI

/// Sets the size of controls within this view.
///
/// ```html
/// <Button modifiers={control_size(:mini) |> button_style(:bordered_prominent)}>Mini</Button>
/// <Button modifiers={control_size(:large) |> button_style(:bordered_prominent)}>Regular</Button>
/// ```
///
/// ## Arguments
/// - ``size``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *)
struct ControlSizeModifier: ViewModifier, Decodable {
    /// The size of controls.
    ///
    /// See ``LiveViewNative/SwiftUI/ControlSize`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let size: ControlSize
    
    func body(content: Content) -> some View {
        #if !os(tvOS)
        content.controlSize(size)
        #endif
    }
}
