//
//  TextFieldProtocol.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI

@_documentation(visibility: public)
protocol TextFieldProtocol: View {
    var text: String? { get nonmutating set }
}

/// Common behaviors and supporting types for text fields.
///
/// ## Topics
/// ### Supporting Types
/// - ``TextFieldStyle``
@_documentation(visibility: public)
extension TextFieldProtocol {
    func valueBinding<S: ParseableFormatStyle>(format: S) -> Binding<S.FormatInput?> where S.FormatOutput == String {
        .init {
            try? text.flatMap(format.parseStrategy.parse)
        } set: {
            text = $0.flatMap(format.format)
        }
    }
    
    var textBinding: Binding<String> {
        Binding {
            text ?? ""
        } set: {
            text = $0
        }
    }
}
