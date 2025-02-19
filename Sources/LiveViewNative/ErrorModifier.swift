//
//  ErrorModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 11/14/22.
//

import SwiftUI

struct ErrorModifier<R: RootRegistry>: ViewModifier {
    let type: String
    let error: any Error
    
    func body(content: Content) -> some View {
        content
            .overlay {
//                AnyErrorView<R>(error)
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
    }
}
