//
//  LabelsHiddenModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/23/2023.
//

import SwiftUI

/// Hides the labels of any child control elements.
///
/// Always provide a label, even if it is hidden,
/// as the labels are still used for accessibility.
///
/// ```html
/// <Toggle
///   modifiers={labels_hidden([])}
///   is-on="toggle"
/// >
///   Labelled Toggle
/// </Toggle>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LabelsHiddenModifier: ViewModifier, Decodable {
    func body(content: Content) -> some View {
        content.labelsHidden()
    }
}

