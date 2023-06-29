//
//  ErrorModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 11/14/22.
//

import SwiftUI

public struct ErrorModifier<R: RootRegistry>: ViewModifier {
    let type: String
    let error: any Error
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                ErrorView<R>(error)
            }
    }
}
