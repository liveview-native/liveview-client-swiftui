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

private struct ModifierChangeTrackingContextKey: EnvironmentKey {
    static let defaultValue: ModifierChangeTrackingContext? = nil
}

final class ModifierChangeTrackingContext {
    var values = [String:WeakRef]()
    
    final class WeakRef {
        weak var value: CurrentValueSubject<any Encodable, Never>?
        
        init(_ value: CurrentValueSubject<any Encodable, Never>) {
            self.value = value
        }
    }
    
    func collect() -> [String:any Encodable] {
        values.compactMapValues(\.value?.value)
    }
    
    func encode(_ values: [String:any Encodable]) throws -> [String:Any] {
        try values.mapValues({
            try JSONSerialization.jsonObject(with: JSONEncoder().encode($0), options: .fragmentsAllowed)
        })
    }
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
    private final class Storage {
        let pushEvent: @MainActor (String, String, Any, Int?) async throws -> [String:Any]?
        let elementChanged: @MainActor (NodeRef) -> ObservableObjectPublisher
        let document: Document
        
        init<R: CustomRegistry>(_ coordinator: LiveViewCoordinator<R>, document: Document) {
            self.pushEvent = coordinator.pushEvent
            self.document = document
            self.elementChanged = coordinator.elementChanged(_:)
        }
    }
    private let storage: Storage
    
    var pushEvent: @MainActor (String, String, Any, Int?) async throws -> [String:Any]? {
        storage.pushEvent
    }
    var elementChanged: @MainActor (NodeRef) -> ObservableObjectPublisher {
        storage.elementChanged
    }
    var document: Document {
        storage.document
    }
    
    @MainActor
    init<R: CustomRegistry>(_ coordinator: LiveViewCoordinator<R>, document: Document) {
        self.storage = .init(coordinator, document: document)
    }
    
    fileprivate struct Key: EnvironmentKey {
        static var defaultValue: CoordinatorEnvironment? = nil
    }
}

/// Additional values provided in the environment within Live Views.
extension EnvironmentValues {
    /// The model for the nearest ancestor `<live-form>` element (or `nil`, if there is no such element).
    public var formModel: FormModel? {
        get { self[FormModelKey.self] }
        set { self[FormModelKey.self] = newValue }
    }
    
    /// The context for collecting `ChangeTracked` properties of a modifier into a single map.
    var modifierChangeTrackingContext: ModifierChangeTrackingContext? {
        get { self[ModifierChangeTrackingContextKey.self] }
        set { self[ModifierChangeTrackingContextKey.self] = newValue }
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
