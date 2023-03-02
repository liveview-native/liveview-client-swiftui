//
//  Picker.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/8/23.
//

import SwiftUI

struct Picker<R: RootRegistry>: View {
    private let context: LiveContext<R>
    @ObservedElement private var element
    @FormState private var value: String?
    @Attribute("picker-style") private var style: PickerStyle = .automatic
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        SwiftUI.Picker(selection: $value) {
            context.buildChildren(of: element, withTagName: "content", namespace: "picker", includeDefaultSlot: false)
        } label: {
            context.buildChildren(of: element, withTagName: "label", namespace: "picker", includeDefaultSlot: false)
        }
        .applyPickerStyle(style)
    }
    
}

private enum PickerStyle: String, AttributeDecodable {
    case automatic
    case inline
#if os(iOS) || os(macOS)
    case menu
#endif
#if !os(macOS)
    case navigationLink = "navigation-link"
#endif
#if os(macOS)
    case radioGroup = "radio-group"
#endif
#if !os(watchOS)
    case segmented
#endif
#if os(iOS) || os(watchOS)
    case wheel
#endif
}

private extension View {
    @ViewBuilder
    func applyPickerStyle(_ style: PickerStyle) -> some View {
        switch style {
        case .automatic:
            self.pickerStyle(.automatic)
        case .inline:
            self.pickerStyle(.inline)
#if os(iOS) || os(macOS)
        case .menu:
            self.pickerStyle(.menu)
#endif
#if !os(macOS)
        case .navigationLink:
            self.pickerStyle(.navigationLink)
#endif
#if os(macOS)
        case .radioGroup:
            self.pickerStyle(.radioGroup)
#endif
#if !os(watchOS)
        case .segmented:
            self.pickerStyle(.segmented)
#endif
#if os(iOS) || os(watchOS)
        case .wheel:
            self.pickerStyle(.wheel)
#endif
        }
    }
}
