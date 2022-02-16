//
//  LiveViewCoordinator.swift
//  PhoenixLiveViewNative
//
//  Created by Brian Cardarella on 4/12/21.
//

import Foundation
import SwiftSoup
import SwiftUI
import SwiftPhoenixClient

private var PUSH_TIMEOUT: Double = 30000

/// The live view coordinator object handles connecting to Phoenix LiveView on the backend, managing the websocket connection, and transmitting/handling events.
public class LiveViewCoordinator: ObservableObject {
    /// The current state of the live view connection.
    @Published public private(set) var state: State = .notConnected
    
    /// The base URL this live view is connected to.
    public let url: URL
    private let connectParams: [String: Any]
    private var phxSession: String = ""
    private var phxStatic: String = ""
    private var phxView: String = ""
    private var phxID: String = ""
    private var phxCSRFToken: String = ""
    @Published internal var elements: Elements = Elements()
    private var socket: Socket!
    private var channel: Channel!
    private var urlSession: URLSession
    private var rendered: [String:Any]!
    private var liveReloadEnabled: Bool = false
    private var liveReloadSocket: Socket?
    private var liveReloadChannel: Channel?
    
    internal let builder: ViewTreeBuilder
    
    /// Creates a new coordinator.
    /// - Parameter url: The URL of the page to establish the connection to.
    /// - Parameter connectParams: A dictionary of parameters to send to the server for use when the LiveView is mounted.
    /// - Parameter registry: The registry of custom views this coordinator will use when building the SwiftUI view tree from the DOM.
    public init(_ url: URL, connectParams: [String: Any] = [:], registry: LiveViewRegistry = .shared) {
        self.url = url
        self.connectParams = connectParams
        self.state = .notConnected
        self.urlSession = URLSession.shared
        self.builder = ViewTreeBuilder(registry: registry)
    }
    
    /// Connects this coordinator to the LiveView channel.
    ///
    /// This function is a no-op unless ``state-swift.property`` is ``State-swift.enum/notConnected``.
    public func connect() {
        guard case .notConnected = state else {
            return
        }
        
        state = .connecting
        
        fetchDOM() { result in
            // todo: parse html off the main thread
            DispatchQueue.main.async {
                switch result {
                case .success(let html):
                    do {
                        let doc = try SwiftSoup.parse(html)
                        let elements = doc.body()!.children()
                        self.phxCSRFToken = try! doc.select("meta[name=\"csrf-token\"]")[0].attr("content")
                        self.liveReloadEnabled = !(try! doc.select("iframe[src=\"/phoenix/live_reload/frame\"]").isEmpty())
                        try self.extractDOMValues(elements)
                        self.connectSocket()
                        self.connectLiveView()
                        
                        // todo: the initial html will be wrong if the LiveView is shared btwn native and web; should we ignore it altogether and wait for rendered upon socket connection?
                        self.elements = try elements.select("div[data-phx-main=\"true\"]")[0].children()
                        self.state = .connected
                    } catch {
                        self.state = .connectionFailed(FetchError.attrParseError)
                    }
                case .failure(let error):
                    self.state = .connectionFailed(error)
                }
            }
        }
    }
    
    private func reconnect() {
        state = .notConnected
        socket?.disconnect()
        liveReloadSocket?.disconnect()
        connect()
    }
    
    func viewTree() -> some View {
        builder.fromElements(self.elements, coordinator: self)
    }
    
    /// Pushes a LiveView event with the given name and payload to the server.
    ///
    /// The client view tree will be updated automatically when the response is received.
    public func pushEvent(_ event: String, payload: Payload) {
        self.channel.push(event, payload: payload, timeout: PUSH_TIMEOUT).receive("ok") { [weak self] reply in
            guard let self = self,
                  let diff = reply.payload["diff"] as? Payload else {
                      return
                  }

            self.rendered = try! DOM.mergeDiff(self.rendered, diff)
            DispatchQueue.main.async {
                self.elements = try! DOM.renderDiff(self.rendered)
            }
        }
    }

    
    private func connectSocket() {
        let cookies = HTTPCookieStorage.shared.cookies(for: self.url)
        
        let configuration = URLSessionConfiguration.default
        for cookie in cookies! {
            configuration.httpCookieStorage!.setCookie(cookie)
        }

        var wsEndpoint = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        wsEndpoint.scheme = url.scheme == "https" ? "wss" : "ws"
        wsEndpoint.path = "/live/websocket"
        self.socket = Socket(endPoint: wsEndpoint.string!, transport: { URLSessionTransport(url: $0, configuration: configuration) }, paramsClosure: {["_csrf_token": self.phxCSRFToken]})
        socket!.onOpen { print("Socket Opened") }
        socket!.onClose { print("Socket Closed") }
        socket!.onError { (error) in print("Socket Error", error) }
        socket!.logger = { message in print("LOG:", message) }
        socket!.connect()
        
        if liveReloadEnabled {
            print("LiveReload: attempting to connect...")
            
            var liveReloadEndpoint = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            liveReloadEndpoint.scheme = url.scheme == "https" ? "wss" : "ws"
            liveReloadEndpoint.path = "/phoenix/live_reload/socket"
            self.liveReloadSocket = Socket(endPoint: liveReloadEndpoint.string!, transport: {
                URLSessionTransport(url: $0, configuration: configuration)
            })
            liveReloadSocket!.connect()
            self.liveReloadChannel = liveReloadSocket!.channel("phoenix:live_reload")
            self.liveReloadChannel!.join().receive("ok") { msg in
                print("LiveReload: connected to channel")
            }.receive("error") { msg in
                print("LiveReload: error connecting to channel: \(msg.payload)")
            }
            self.liveReloadChannel!.on("assets_change") { [unowned self] _ in
                DispatchQueue.main.async {
                    print("LiveReload: assets changed, reloading")
                    // need to fully reconnect (rather than just re-join channel) because the elixir code reloader only triggers on http reqs
                    self.reconnect()
                }
            }
        }
    }
    
    // todo: don't use Any for the params
    private func connectLiveView() {
        var connectParams = connectParams
        connectParams["_mounts"] = 0
        connectParams["_csrf_token"] = self.phxCSRFToken
        connectParams["_native"] = true
        
        self.channel = self.socket.channel("lv:\(self.phxID)", params: ["session": self.phxSession, "static": self.phxStatic, "url": url.absoluteString, "params": connectParams])
        self.channel.join()
            .receive("ok") { message in
                self.rendered = (message.payload["rendered"] as! [String:Any])
                DispatchQueue.main.async {
                    // todo: what should happen when renderDiff fails?
                    self.elements = try! DOM.renderDiff(self.rendered)
                }
            }
            .receive("error") { message in print("Failed to join", message.payload) }
        self.channel.onError { (payload) in print("Error: ", payload) }
        self.channel.onClose { (payload) in print("Channel Closed") }
        self.channel.on("diff") { (message) in
            do {
                self.rendered = try DOM.mergeDiff(self.rendered, message.payload)
                DispatchQueue.main.async {
                    do {
                        self.elements = try DOM.renderDiff(self.rendered)
                    } catch {
                        print("Error during render")
                    }
                }
            } catch {
                print("Error during merge!")
            }
        }
    }
    
    private func extractDOMValues(_ elements: Elements)throws -> Void {
        let mainDiv = try elements.select("div[data-phx-main=\"true\"]")[0]
        self.phxSession = try mainDiv.attr("data-phx-session")
        self.phxStatic = try mainDiv.attr("data-phx-static")
        self.phxView = try mainDiv.attr("data-phx-view")
        self.phxID = try mainDiv.attr("id")
    }
    
    private func fetchDOM(_ completion: @escaping (Result<String, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: self.url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data, let html = String(data: data, encoding: .utf8) {
                completion(.success(html))
            } else {
                completion(.failure(FetchError.other(response!)))
            }
        }
        
        task.resume()
    }
}

extension LiveViewCoordinator {
    /// The live view connection state.
    public enum State {
        /// The coordinator has not yet connected to the live view.
        case notConnected
        /// The coordinator is attempting to connect.
        case connecting
        /// The coordinator has connected and the view tree can be rendered.
        case connected
        // todo: disconnected state?
        /// The coordinator failed to connect and produced the given error.
        case connectionFailed(Error)
    }
}

extension LiveViewCoordinator {
    enum FetchError: Error {
        case parseError
        case attrParseError
        case other(URLResponse)
    }
}
