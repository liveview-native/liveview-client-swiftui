//
//  LiveErrorView.swift
//
//
//  Created by Carson Katri on 1/31/24.
//

import SwiftUI

/// A View that renders a ``LiveConnectionError``, or a fallback View.
/// This can be used to display the stack trace HTML returned by Phoenix when debugging.
///
/// When the app is built in release configuration, the `fallback` will always be used.
public struct LiveErrorView<Fallback: View>: View {
    let error: Error
    let fallback: Fallback
    
    public init(error: Error, @ViewBuilder fallback: () -> Fallback) {
        self.error = error
        self.fallback = fallback()
    }
    
    public var body: some View {
        #if DEBUG
        if let error = error as? LiveConnectionError,
           case let .initialFetchUnexpectedResponse(_, trace?) = error
        {
            WebErrorView(html: trace)
        } else {
            fallback
        }
        #else
        fallback
        #endif
    }
}
