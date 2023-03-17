//
//  Environment.swift
// LiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI
import LiveViewNativeCore
import Combine

private struct FormModelKey: EnvironmentKey {
    static let defaultValue: FormModel? = nil
}

private struct ElementKey: EnvironmentKey {
    static let defaultValue: ElementNode? = nil
}

private struct LiveContextStorageKey: EnvironmentKey {
    static var defaultValue: Any? = nil
}

/// Provides access to ``LiveViewCoordinator`` properties via the environment.
/// This exists to type-erase the coordinator, since environment properties can't be generic.
struct CoordinatorEnvironment {
    let pushEvent: @MainActor (String, String, Any, Int?) async throws -> Void
    let elementChanged: AnyPublisher<NodeRef, Never>
    let document: Document
    
    @MainActor
    init<R: CustomRegistry>(_ coordinator: LiveViewCoordinator<R>, document: Document) {
        self.pushEvent = coordinator.pushEvent
        self.document = document
        self.elementChanged = coordinator.elementChanged.eraseToAnyPublisher()
    }
    
    fileprivate struct Key: EnvironmentKey {
        static var defaultValue: CoordinatorEnvironment? = nil
    }
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
    
    var coordinatorEnvironment: CoordinatorEnvironment? {
        get { self[CoordinatorEnvironment.Key.self] }
        set { self[CoordinatorEnvironment.Key.self] = newValue }
    }
    
    // This property should only be accessed via the `@LiveContext` property wrapper.
    var anyLiveContextStorage: Any? {
        get { self[LiveContextStorageKey.self] }
        set { self[LiveContextStorageKey.self] = newValue }
    }
}
