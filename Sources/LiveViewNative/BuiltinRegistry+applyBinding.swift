//
//  BuiltinRegistry+applyBinding.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI
import LiveViewNativeCore

extension BuiltinRegistry {
    @ViewBuilder
    static func applyBinding<R: CustomRegistry>(
        _ binding: AttributeName,
        event: String,
        value: Payload,
        to view: some View,
        element: ElementNode,
        context: LiveContext<R>
    ) -> some View {
        ProvidedBindingsReader(
            binding: binding.rawValue,
            content: view
        ) {
            switch binding {
            case "phx-window-focus":
                ScenePhaseObserver(content: view, target: .active, type: "focus", event: event, value: value)
            case "phx-window-blur":
                ScenePhaseObserver(content: view, target: .background, type: "blur", event: event, value: value)
            case "phx-focus":
                FocusObserver(content: view, target: true, type: "focus", event: event, value: value)
            case "phx-blur":
                FocusObserver(content: view, target: false, type: "blur", event: event, value: value)
            case "phx-click":
                TapGestureView(content: view, type: "click", event: event, value: value)
            default:
                view
            }
        }
    }
}

/// A preference key that specifies what bindings the View handles internally.
enum ProvidedBindingsKey: PreferenceKey {
    static var defaultValue: Set<String> { [] }
    static func reduce(value: inout Set<String>, nextValue: () -> Set<String>) {
        value = nextValue()
    }
}

fileprivate struct ProvidedBindingsReader<Content: View, ApplyBinding: View>: View {
    let binding: String
    let content: Content
    @ViewBuilder let applyBinding: () -> ApplyBinding
    @State private var providesBinding: Bool = false
    
    var body: some View {
        SwiftUI.Group {
            if providesBinding {
                content
            } else {
                applyBinding()
            }
        }
        .onPreferenceChange(ProvidedBindingsKey.self) { self.providesBinding = $0.contains(binding) }
    }
}

fileprivate struct ScenePhaseObserver<Content: View>: View {
    @Environment(\.scenePhase) var scenePhase
    
    let content: Content
    let target: ScenePhase
    let _event: Event
    let value: Payload
    
    init(content: Content, target: ScenePhase, type: String, event: String, value: Payload) {
        self.content = content
        self.target = target
        self._event = .init(event: event, type: type)
        self.value = value
    }
    
    var body: some View {
        content
            .onChange(of: scenePhase) { newValue in
                guard newValue == target else { return }
                _event.wrappedValue(value) {}
            }
    }
}

fileprivate struct FocusObserver<Content: View>: View {
    @FocusState private var isFocused: Bool
    
    let content: Content
    let target: Bool
    let _event: Event
    let value: Payload
    
    init(content: Content, target: Bool, type: String, event: String, value: Payload) {
        self.content = content
        self.target = target
        self._event = .init(event: event, type: type)
        self.value = value
    }
    
    var body: some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { newValue in
                guard newValue == target else { return }
                _event.wrappedValue(value) {}
            }
    }
}

fileprivate struct TapGestureView<Content: View>: View {
    let content: Content
    let _event: Event
    let value: Payload
    
    init(content: Content, type: String, event: String, value: Payload) {
        self.content = content
        self._event = .init(event: event, type: type)
        self.value = value
    }
    
    var body: some View {
        content
            .onTapGesture {
                _event.wrappedValue(value) {}
            }
    }
}
