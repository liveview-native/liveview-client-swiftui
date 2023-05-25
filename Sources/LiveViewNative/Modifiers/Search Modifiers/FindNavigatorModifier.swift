//
//  FindNavigatorModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/19/2023.
//

import SwiftUI

/// Controls whether the find navigator is shown.
///
/// Use this modifier with a ``TextEditor``:
///
/// ```html
/// <TextEditor value-binding="my_text" modifiers={find_navigator(@native, is_presented: :show)} />
/// ```
///
/// ## Arguments
/// * ``isPresented``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, *)
struct FindNavigatorModifier: ViewModifier, Decodable {
    /// A binding that controls whether the find navigator is shown.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @LiveBinding private var isPresented: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._isPresented = try LiveBinding(decoding: .isPresented, in: container)
    }

    func body(content: Content) -> some View {
        content
            #if os(iOS)
            .findNavigator(isPresented: $isPresented)
            #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case isPresented
    }
}
