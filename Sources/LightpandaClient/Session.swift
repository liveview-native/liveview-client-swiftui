import lightpanda


final class Session {
    var address: UnsafeMutableRawPointer!
    
    init(address: UnsafeMutableRawPointer?) {
        self.address = address
    }
    
    func createPage() -> Page {
        return Page(address: lightpanda_session_create_page(address))
    }
    
    var page: Page {
        Page(address: lightpanda_session_page(address))
    }
}
