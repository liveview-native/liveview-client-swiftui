//
//  GridColumnAlignmentModifier.swift
//  
//
//  Created by Carson Katri on 2/14/23.
//

import SwiftUI

struct GridColumnAlignmentModifier: ViewModifier, Decodable, Equatable {
    private let guide: HorizontalAlignment
    
    func body(content: Content) -> some View {
        content.gridColumnAlignment(guide)
    }
}
