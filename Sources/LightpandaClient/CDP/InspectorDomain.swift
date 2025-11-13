extension CDP {
    struct Inspector {
        // Methods
        
        struct Enable: CDP.Method {
            static let method = "Inspector.enable"
            
            struct Response: Decodable, Sendable {}
        }
    }
}
