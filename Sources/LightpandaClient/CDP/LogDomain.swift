extension CDP {
    struct Log {
        // Methods
        
        struct Enable: CDP.Method {
            static let method = "Log.enable"
            
            struct Response: Decodable, Sendable {}
        }
    }
}
