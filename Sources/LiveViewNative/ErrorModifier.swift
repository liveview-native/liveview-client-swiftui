//
//  ErrorModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 11/14/22.
//

import SwiftUI

struct ErrorModifier: ViewModifier {
    let type: String
    let error: any Error
    
    func body(content: Content) -> some View {
        VStack {
            Text("Error Decoding Modifier of Type '\(type)'")
            Text(String(describing: error))
        }
    }
}
