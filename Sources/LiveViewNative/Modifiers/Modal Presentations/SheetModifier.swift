//
//  SheetModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// A modifier that presents another view as a sheet when a binding is activated.
///
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(@native, content: :content, is_presented: :show)}>
///   Present Sheet
///   <VStack template={:content}>
///     <Text>Hello, world!</Text>
///     <Button phx-click="toggle">Dismiss</Button>
///   </VStack>
/// </Button>
/// ```
///
///## Arguments
///- ``isPresented``
///- ``onDismiss``
///- ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SheetModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The live binding that controls when the sheet is presented.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding private var isPresented: Bool
    
    /// An optional event to trigger when the sheet is dismissed.
    ///
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event private var onDismiss: Event.EventHandler
    
    /// A reference to the content view for the sheet.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._isPresented = try LiveBinding(decoding: .isPresented, in: container)
        self._onDismiss = try container.decode(Event.self, forKey: .onDismiss)
        self.content = try container.decode(String.self, forKey: .content)
    }
    
    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented, onDismiss: $onDismiss) {
            context.buildChildren(of: element, forTemplate: self.content)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case isPresented
        case onDismiss
        case content
    }
}
