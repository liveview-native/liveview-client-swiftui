//
//  TextField.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct TextField<R: RootRegistry>: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    let context: LiveContext<R>
    @FormState var value: String?
    @FocusState private var isFocused: Bool
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        field
            .focused($isFocused)
            .onChange(of: isFocused, perform: handleFocus)
            .applyTextFieldStyle(textFieldStyle)
            .applyAutocorrectionDisabled(disableAutocorrection)
#if !os(macOS)
            .textInputAutocapitalization(autocapitalization)
#endif
#if os(iOS) || os(tvOS)
            .applyKeyboardType(keyboard)
#endif
            .applySubmitLabel(submitLabel)
    }
    
    @ViewBuilder
    private var field: some View {
        if let format = element.attributeValue(for: "format") {
            switch format {
            case "date-time":
                SwiftUI.TextField(
                    value: valueBinding(format: .dateTime),
                    format: .dateTime,
                    prompt: prompt
                ) {
                    label
                }
            case "url":
                SwiftUI.TextField(
                    value: valueBinding(format: .url),
                    format: .url,
                    prompt: prompt
                ) {
                    label
                }
            case "iso8601":
                SwiftUI.TextField(
                    value: valueBinding(format: .iso8601),
                    format: .iso8601,
                    prompt: prompt
                ) {
                    label
                }
            case "number":
                SwiftUI.TextField(
                    value: valueBinding(format: .number),
                    format: .number,
                    prompt: prompt
                ) {
                    label
                }
            case "percent":
                SwiftUI.TextField(
                    value: valueBinding(format: .percent),
                    format: .percent,
                    prompt: prompt
                ) {
                    label
                }
            case "currency":
                if let code = element.attributeValue(for: "currency-code") {
                    SwiftUI.TextField(
                        value: valueBinding(format: .currency(code: code)),
                        format: .currency(code: code),
                        prompt: prompt
                    ) {
                        label
                    }
                } else {
                    SwiftUI.TextField(
                        text: textBinding,
                        prompt: prompt,
                        axis: axis
                    ) {
                        label
                    }
                }
            case "name":
                if let style = element.attributeValue(for: "name-style") {
                    let nameStyle: PersonNameComponents.FormatStyle.Style = {
                        switch style {
                        case "short":
                            return .short
                        case "medium":
                            return .medium
                        case "long":
                            return .long
                        case "abbreviated":
                            return .abbreviated
                        default:
                            return .medium
                        }
                    }()
                    SwiftUI.TextField(
                        value: valueBinding(format: .name(style: nameStyle)),
                        format: .name(style: nameStyle),
                        prompt: prompt
                    ) {
                        label
                    }
                } else {
                    SwiftUI.TextField(
                        text: textBinding,
                        prompt: prompt,
                        axis: axis
                    ) {
                        label
                    }
                }
            default:
                SwiftUI.TextField(
                    text: textBinding,
                    prompt: prompt,
                    axis: axis
                ) {
                    label
                }
            }
        } else {
            SwiftUI.TextField(
                text: textBinding,
                prompt: prompt,
                axis: axis
            ) {
                label
            }
        }
    }
}
