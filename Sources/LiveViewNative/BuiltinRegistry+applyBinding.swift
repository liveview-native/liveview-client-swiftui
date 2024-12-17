//
//  BuiltinRegistry+applyBinding.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI
import LiveViewNativeCore

public enum _EventBinding: String {
    case windowFocus = "phx-window-focus"
    case windowBlur = "phx-window-blur"
    case focus = "phx-focus"
    case blur = "phx-blur"
    case click = "phx-click"
}

extension BuiltinRegistry {
    @MainActor
    @ViewBuilder
    static func applyBinding(
        _ binding: _EventBinding,
        event: String,
        value: Payload,
        to view: some View,
        element: ElementNode
    ) -> some View {
        ProvidedBindingsReader(
            binding: binding,
            content: view
        ) {
            switch binding {
            case .windowFocus:
                ScenePhaseObserver(content: view, target: .active, type: "focus", event: event, value: value)
            case .windowBlur:
                ScenePhaseObserver(content: view, target: .background, type: "blur", event: event, value: value)
            case .focus:
                FocusObserver(content: view, target: true, type: "focus", event: event, value: value)
            case .blur:
                FocusObserver(content: view, target: false, type: "blur", event: event, value: value)
            case .click:
                TapGestureView(content: view, type: "click", event: event, value: value)
            }
        }
    }
}

/// A preference key that specifies what bindings the View handles internally.
public enum _ProvidedBindingsKey: PreferenceKey {
    public static var defaultValue: Set<_EventBinding> { [] }
    public static func reduce(
        value: inout Set<_EventBinding>,
        nextValue: () -> Set<_EventBinding>
    ) {
        value = nextValue()
    }
}

fileprivate struct ProvidedBindingsReader<Content: View, ApplyBinding: View>: View {
    let binding: _EventBinding
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
        .onPreferenceChange(_ProvidedBindingsKey.self) { self.providesBinding = $0.contains(binding) }
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
                _event.wrappedValue(value: value) {}
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
                _event.wrappedValue(value: value) {}
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
                _event.wrappedValue(value: value) {}
            }
    }
}
