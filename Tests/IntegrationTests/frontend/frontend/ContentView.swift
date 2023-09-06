//
//  ContentView.swift
//  frontend
//
//  Created by Carson.Katri on 9/5/23.
//

import SwiftUI
import LiveViewNative

struct ContentView: View {
    var body: some View {
        LiveView(.localhost(path: CommandLine.arguments[1]))
    }
}
