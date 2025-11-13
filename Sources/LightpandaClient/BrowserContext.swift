import lightpanda


final class BrowserContext {
    var address: UnsafeMutableRawPointer!
    
    init(address: UnsafeMutableRawPointer) {
        self.address = address
    }
    
    var session: Session {
        Session(address: lightpanda_browser_context_session(address))
    }
}
