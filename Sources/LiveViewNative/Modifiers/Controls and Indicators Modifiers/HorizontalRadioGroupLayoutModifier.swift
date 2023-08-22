//
//  HorizontalRadioGroupLayoutModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/26/23.
//

import SwiftUI

/// Changes radio-group style ``Picker``s to lay out horizontally.
///
/// ```html
/// <Picker modifiers={picker_style(:radio_group) |> horizontal_radio_group_layout()}>
///     ...
/// </Picker>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, *)
struct HorizontalRadioGroupLayoutModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        content
            #if os(macOS)
            .horizontalRadioGroupLayout()
            #endif
    }
}
