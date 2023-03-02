//
//  Form.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 1/18/23.
//

import SwiftUI

struct Form<R: RootRegistry>: View {
    @ObservedElement private var element
    private let context: LiveContext<R>
    
    @Attribute("form-style") private var style: FormStyle = .automatic
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        SwiftUI.Form {
            context.buildChildren(of: element)
        }
        .applyFormStyle(style)
    }
}

private enum FormStyle: String, AttributeDecodable {
    case automatic, columns, grouped
}

private extension View {
    @ViewBuilder
    func applyFormStyle(_ style: FormStyle) -> some View {
        switch style {
        case .automatic:
            self.formStyle(.automatic)
        case .columns:
            self.formStyle(.columns)
        case .grouped:
            self.formStyle(.grouped)
        }
    }
}
