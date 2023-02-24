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
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        SwiftUI.Form {
            context.buildChildren(of: element)
        }
        .applyFormStyle(formStyle)
    }
    
    private var formStyle: FormStyle {
        element.attributeValue(for: "form-style").flatMap(FormStyle.init) ?? .automatic
    }
}

private enum FormStyle: String {
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
