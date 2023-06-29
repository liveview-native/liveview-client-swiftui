//
//  LiveViewHost.swift
//  
//
//  Created by Carson Katri on 6/29/23.
//

import Foundation

/// The information needed to locate a server hosting a LiveView.
public protocol LiveViewHost {
    var url: URL { get }
}

public struct LocalhostLiveViewHost: LiveViewHost {
    public let url: URL
    
    init(port: Int) {
        self.url = .init(string: "http://localhost:\(port)")!
    }
}

public extension LiveViewHost where Self == LocalhostLiveViewHost {
    /// A server at `http://localhost:4000`.
    static var localhost: Self { .init(port: 4000) }
    /// A server at `localhost` on the given port.
    static func localhost(port: Int) -> Self { .init(port: port) }
}

public struct CustomLiveViewHost: LiveViewHost {
    public let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
}

public extension LiveViewHost where Self == CustomLiveViewHost {
    /// A server at a custom `URL`.
    static func custom(_ url: URL) -> Self { .init(url) }
}

public struct AutomaticLiveViewHost: LiveViewHost {
    public let url: URL
    
    init(
        development: some LiveViewHost,
        production: some LiveViewHost
    ) {
        #if DEBUG
        self.url = development.url
        #else
        self.url = production.url
        #endif
    }
}

public extension LiveViewHost where Self == AutomaticLiveViewHost {
    /// Automatically select a host based on the `DEBUG` compiler directive.
    static func automatic(development: some LiveViewHost, production: some LiveViewHost) -> Self {
        .init(development: development, production: production)
    }
    
    /// Automatically select a host based on the `DEBUG` compiler directive.
    static func automatic(_ url: URL) -> Self {
        .init(development: .localhost, production: .custom(url))
    }
}
