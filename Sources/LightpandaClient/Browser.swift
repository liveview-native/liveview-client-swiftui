import lightpanda


final class Browser {
    var address: UnsafeMutableRawPointer!
    
    init(address: UnsafeMutableRawPointer?) {
        self.address = address
    }
    
    
    deinit {
        lightpanda_browser_deinit(address)
    }
    
    
    func newSession() -> Session {
        return Session(address: lightpanda_browser_new_session(address))
    }
}
