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
        SwiftUI.VStack {
            SwiftUI.Text("Error Decoding Modifier of Type '\(type)'")
            SwiftUI.Text(String(describing: error))
        }
    }
}
