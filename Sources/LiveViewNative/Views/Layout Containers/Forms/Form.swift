//
//  Form.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 1/18/23.
//

import SwiftUI

/// A container for grouping labeled form controls in a consistent style.
///
/// - Note: This element does not provide a form data model. See [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form).
@_documentation(visibility: public)
struct Form<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    var body: some View {
        SwiftUI.Form {
            context.buildChildren(of: element)
        }
    }
}
