import lightpanda

@MainActor
public final class BrowserContext {
    var address: UnsafeMutableRawPointer!
    
    init(address: UnsafeMutableRawPointer) {
        self.address = address
    }
    
    public var session: Session {
        Session(address: lightpanda_browser_context_session(address))
    }
}
