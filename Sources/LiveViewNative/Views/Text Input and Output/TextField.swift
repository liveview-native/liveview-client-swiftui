//
//  TextField.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct TextField<R: RootRegistry>: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    @LiveContext<R> var context
    @FormState var value: String?
    @FocusState private var isFocused: Bool
    
    let focusEvent = Event("phx-focus", type: "focus")
    let blurEvent = Event("phx-blur", type: "blur")
    @Attribute("format") private var format: String?
    @Attribute("currency-code") private var currencyCode: String?
    @Attribute(
        "name-style",
        transform: {
            switch $0?.value {
            case "short":
                return .short
            case "medium":
                return .medium
            case "long":
                return .long
            case "abbreviated":
                return .abbreviated
            default:
                return nil
            }
        }
    ) private var nameStyle: PersonNameComponents.FormatStyle.Style?
    
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
            .preference(key: ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
    }
    
    @ViewBuilder
    private var field: some View {
        if let format {
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
                if let currencyCode {
                    SwiftUI.TextField(
                        value: valueBinding(format: .currency(code: currencyCode)),
                        format: .currency(code: currencyCode),
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
                if let nameStyle {
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
    
    var label: some View {
        context.buildChildren(of: element)
    }
}
