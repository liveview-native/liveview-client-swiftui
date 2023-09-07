//
//  frontendApp.swift
//  frontend
//
//  Created by Carson.Katri on 9/5/23.
//

import SwiftUI
import LiveViewNative

@main
struct frontendApp: App {
    var body: some Scene {
        WindowGroup {
            LiveView(.localhost(path: CommandLine.arguments[1]))
        }
    }
}
