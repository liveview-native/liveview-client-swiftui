//
//  CompiledLVNStylesheet.swift
//
//
//  Created by Carson Katri on 10/26/23.
//

import SwiftUI
import LiveViewNativeStylesheet

struct CompiledLVNStylesheet<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    @Attribute("body") private var stylesheet: Stylesheet<R>
    
    var body: some View {
        context.buildChildren(of: element)
            .transformEnvironment(\.stylesheets) { stylesheets in
                let id = ObjectIdentifier(R.self)
                if let previousValue = stylesheets[id] {
                    stylesheets[id] = (previousValue as! Stylesheet<R>).merge(with: stylesheet)
                } else {
                    stylesheets[id] = stylesheet
                }
            }
    }
}

extension EnvironmentValues {
    private enum StylesheetsKey: EnvironmentKey {
        static var defaultValue: [ObjectIdentifier:any StylesheetProtocol] {
            [:]
        }
    }
    
    var stylesheets: [ObjectIdentifier:any StylesheetProtocol] {
        get { self[StylesheetsKey.self] }
        set { self[StylesheetsKey.self] = newValue }
    }
}
