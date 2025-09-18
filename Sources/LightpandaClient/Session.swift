import lightpanda

@MainActor
public final class Session {
    var address: UnsafeMutableRawPointer!
    
    init(address: UnsafeMutableRawPointer?) {
        self.address = address
    }
    
    public func createPage() -> Page {
        return Page(address: lightpanda_session_create_page(address))
    }
    
    public var page: Page {
        Page(address: lightpanda_session_page(address))
    }
}
