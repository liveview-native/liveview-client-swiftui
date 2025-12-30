//
//  TextField.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LightpandaClient

/// A form element for entering text.
///
/// Any children of the field will be used as the label.
///
/// ```html
/// <TextField text="first_name">
///     First Name
/// </TextField>
/// ```
///
/// You can style the label by using elements inside.
///
/// ```html
/// <TextField text="last_name">
///     <Text fontWeight="bold" font="caption">Last Name</Text>
/// </TextField>
/// ```
///
/// ### Input Configuration
/// Use modifiers to configure how text is input.
///
/// ```elixir
/// "search-field" do
///   autocorrectDisabled(true)
///   textInputAutocapitalization(.words)
///   keyboardType(.webSearch)
///   submitLabel(.search)
/// end
/// ```
///
/// ```html
/// <TextField
///     text="value"
///     class="search-field"
/// >
///     Enter Search Text
/// </TextField>
/// ```
///
/// ### Formatting Values
/// Use the ``format`` attribute to input values such as numbers and URLs.
///
/// ```html
/// <VStack>
///     <TextField
///         text="amount"
///         format="currency"
///         currencyCode="usd"
///         class="decimal-pad"
///     >
///         Enter Amount
///     </TextField>
///
///     <TextField
///         text="bank_address"
///         axis="vertical"
///     >
///         Enter Bank Address
///     </TextField>
/// </VStack>
/// ```
///
/// ### Secure Input
/// To input private text, such as a password, use ``SecureField``.
///
/// ## Attributes
/// * ``text``
/// * ``format``
/// * ``currencyCode``
/// * ``nameStyle``
/// * ``TextFieldProtocol/axis``
/// * ``TextFieldProtocol/prompt``
///
/// ## Events
/// * ``focusEvent``
/// * ``blurEvent``
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
@_documentation(visibility: public)
struct TextField<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    var text: String? {
        get { node.value }
        nonmutating set {
            let value = newValue ?? ""
            node.value = value
            Task {
                try? await node.callFunction(runtime: lightpanda, function: #"""
                function() {
                    this.value = \#(String(data: try! JSONEncoder().encode(value), encoding: .utf8)!);
                }
                """#)
            }
        }
    }
    
    /// The axis to scroll when the content doesn't fit.
    ///
    /// Possible values:
    /// * `horizontal`
    /// * `vertical`
    var axis: Axis {
        node.attributeValue(for: "axis", strategy: .axis) ?? .horizontal
    }
    
    /// Additional guidance on what to enter.
    var prompt: String? {
        node.attributeValue(for: "prompt")
    }

    /// Possible values:
    /// * `date-time`
    /// * `url`
    /// * `iso8601`
    /// * `number`
    /// * `percent`
    /// * `currency`
    /// * `name`
    @_documentation(visibility: public)
    private var format: String? {
        node.attributeValue(for: "format")
    }
    
    /// The currency code for the locale.
    ///
    /// Example currency codes include `USD`, `EUR`, and `JPY`.
    @_documentation(visibility: public)
    private var currencyCode: String? {
        node.attributeValue(for: "currencyCode")
    }
    
    /// A type used to format a person’s name with a style appropriate for the given locale.
    /// 
    /// Possible values:
    /// * `short`
    /// * `medium`
    /// * `long`
    /// * `abbreviated`
    @_documentation(visibility: public)
    private var nameStyle: PersonNameComponents.FormatStyle.Style? {
        node.attributeValue(for: "nameStyle", strategy: PersonNameComponentsFormatStyleStyleParseStrategy())
    }
    
    var body: some View {
        field
            .task {
                let id = UUID().uuidString
                let binding = try! await lightpanda.cdp.addBinding(name: id) { [weak node] call in
                    node?.value = call.payload
                }
                
                defer {
                    Task { try! await lightpanda.cdp.removeBinding(name: id) }
                }
                
                try! await self.node.callFunction(runtime: lightpanda, function: #"""
                function() {
                    let internalValue = this.value;
                    Object.defineProperty(this, "value", {
                        get() { return internalValue; },
                        set(newValue) {
                            internalValue = newValue;
                            globalThis["\#(id)"](newValue);
                        },
                        configurable: true
                    });
                }
                """#)
            }
            .onChange(of: text) { oldValue, newValue in
                Task {
                    try! await self.node.callFunction(
                        runtime: lightpanda,
                        function: #"""
                        function() {
                            this.value = \#(String(data: try! JSONEncoder().encode(newValue ?? ""), encoding: .utf8)!);
                            this.dispatchEvent(new Event("input", {
                                inputType: "insertText",
                                data: "\#(newValue?.last ?? " ")",
                                bubbles: true
                            }));
                        }
                        """#
                    )
                }
            }
            .onKeyPress(phases: .all) { press in
                let event = switch press.phase {
                case .down:
                    "keydown"
                case .up:
                    "keyup"
                case .repeat:
                    "keydown"
                default:
                    fatalError("Unhandled KeyPress.Phase \(press.phase)")
                }
                Task {
                    let keypressEvent = if case .down = press.phase {
                        // also send a 'keypress' event
                        #"""
                        this.dispatchEvent(new KeyboardEvent("keypress", {
                            key: \#(String(data: try! JSONEncoder().encode(press.characters), encoding: .utf8)!),
                            repeat: \#(press.phase == .repeat),
                            ctrlKey: \#(press.modifiers.contains(.control) ? "true" : "false"),
                            metaKey: \#(press.modifiers.contains(.command) ? "true" : "false"),
                            shiftKey: \#(press.modifiers.contains(.shift) ? "true" : "false"),
                            bubbles: true
                        }));
                        """#
                    } else { "" }
                    try! await self.node.callFunction(
                        runtime: lightpanda,
                        function: #"""
                        function() {
                            this.dispatchEvent(new KeyboardEvent("\#(event)", {
                                key: \#(String(data: try! JSONEncoder().encode(press.characters), encoding: .utf8)!),
                                repeat: \#(press.phase == .repeat),
                                ctrlKey: \#(press.modifiers.contains(.control) ? "true" : "false"),
                                metaKey: \#(press.modifiers.contains(.command) ? "true" : "false"),
                                shiftKey: \#(press.modifiers.contains(.shift) ? "true" : "false"),
                                bubbles: true
                            }));
                            \#(keypressEvent)
                        }
                        """#
                    )
                }
                return .ignored
            }
    }
    
    @ViewBuilder
    private var field: some View {
        if let format {
            switch format {
            case "dateTime":
                SwiftUI.TextField(
                    value: valueBinding(format: .dateTime),
                    format: .dateTime,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "url":
                SwiftUI.TextField(
                    value: valueBinding(format: .url),
                    format: .url,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "iso8601":
                SwiftUI.TextField(
                    value: valueBinding(format: Date.ISO8601FormatStyle()),
                    format: .iso8601,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "number":
                SwiftUI.TextField(
                    value: valueBinding(format: .number),
                    format: .number,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "percent":
                SwiftUI.TextField(
                    value: valueBinding(format: .percent),
                    format: .percent,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "currency":
                if let currencyCode {
                    SwiftUI.TextField(
                        value: valueBinding(format: .currency(code: currencyCode)),
                        format: .currency(code: currencyCode),
                        prompt: prompt.flatMap(SwiftUI.Text.init)
                    ) {
                        label
                    }
                } else {
                    SwiftUI.TextField(
                        text: textBinding,
                        prompt: prompt.flatMap(SwiftUI.Text.init),
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
                        prompt: prompt.flatMap(SwiftUI.Text.init)
                    ) {
                        label
                    }
                } else {
                    SwiftUI.TextField(
                        text: textBinding,
                        prompt: prompt.flatMap(SwiftUI.Text.init),
                        axis: axis
                    ) {
                        label
                    }
                }
            default:
                SwiftUI.TextField(
                    text: textBinding,
                    prompt: prompt.flatMap(SwiftUI.Text.init),
                    axis: axis
                ) {
                    label
                }
            }
        } else {
            SwiftUI.TextField(
                text: textBinding,
                prompt: prompt.flatMap(SwiftUI.Text.init),
                axis: axis
            ) {
                label
            }
        }
    }
    
    var label: some View {
        node.children(library: Library.self)
    }
    
    // MARK: - Binding Helpers
    
    private func valueBinding<S: ParseableFormatStyle>(format: S) -> Binding<S.FormatInput?> where S.FormatOutput == String {
        .init {
            try? text.flatMap(format.parseStrategy.parse)
        } set: {
            text = $0.flatMap(format.format)
        }
    }
    
    private var textBinding: Binding<String> {
        Binding {
            text ?? ""
        } set: {
            text = $0
        }
    }
}

extension ParseStrategy where Self == AxisParseStrategy {
    static var axis: AxisParseStrategy { AxisParseStrategy() }
}

struct AxisParseStrategy: ParseStrategy {
    typealias ParseInput = String
    typealias ParseOutput = Axis
    
    func parse(_ value: String) throws -> Axis {
        switch value {
        case "horizontal":
            return .horizontal
        case "vertical":
            return .vertical
        default:
            throw ParseError()
        }
    }
}

