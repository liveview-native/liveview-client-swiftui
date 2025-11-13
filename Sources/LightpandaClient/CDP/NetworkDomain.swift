extension CDP {    
    struct Network {
        // Methods
        
        struct Enable: CDP.Method {
            static let method = "Network.enable"
            
            let maxPostDataSize: Int
            let reportDirectSocketTraffic: Bool
            
            struct Response: Decodable, Sendable {}
        }
    }
}
