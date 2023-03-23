//
//  Project.swift
//  
//
//  Created by Carson Katri on 3/21/23.
//

enum Project: String {
    case backend
    case app
    
    var path: String {
        switch self {
        case .backend:
            return "lvn_tutorial_backend"
        case .app:
            return "LVNTutorialApp"
        }
    }
}
