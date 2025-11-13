import lightpanda
import Foundation


final class Page {
    var address: UnsafeMutableRawPointer!
    
    init(address: UnsafeMutableRawPointer?) {
        self.address = address
    }
    
    func navigate(to url: URL) {
        lightpanda_page_navigate(address, url.absoluteString)
    }
}
