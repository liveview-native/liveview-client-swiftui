//
//  PresentationDetentsModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// `PresentationDetent` cannot be encoded, and therefore is not compatible with `ChangeTracked`.
@ParseableExpression
struct _PresentationDetentsModifier: ViewModifier {
    static let name = "presentationDetents"

    let detents: Set<PresentationDetent>
    
    init(_ detents: Set<PresentationDetent>) {
        self.detents = detents
    }
    
    func body(content: Content) -> some View {
        content.presentationDetents(detents)
    }
}
