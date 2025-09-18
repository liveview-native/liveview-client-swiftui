import lightpanda

@MainActor
public final class Browser {
    var address: UnsafeMutableRawPointer!
    
    init(address: UnsafeMutableRawPointer?) {
        self.address = address
    }
    
    @MainActor
    deinit {
        lightpanda_browser_deinit(address)
    }
    
    public func newSession() -> Session {
        return Session(address: lightpanda_browser_new_session(address))
    }
}
