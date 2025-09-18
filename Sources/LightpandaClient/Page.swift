import lightpanda
import Foundation

@MainActor
public final class Page {
    var address: UnsafeMutableRawPointer!
    
    init(address: UnsafeMutableRawPointer?) {
        self.address = address
    }
    
    public func navigate(to url: URL) {
        lightpanda_page_navigate(address, url.absoluteString)
    }
}
