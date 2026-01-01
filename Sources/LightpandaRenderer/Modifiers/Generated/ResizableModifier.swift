//
//  ResizableModifier.swift
//  LightpandaRenderer
//
//  Auto-generated modifier for Image.resizable()
//

import SwiftUI
import SwiftSyntax

/// Image modifier for `resizable(capInsets:resizingMode:)`
@MainActor
enum ResizableModifier: RuntimeImageModifier {
    case resizable0
    case resizable1(capInsets: EdgeInsets)
    case resizable2(resizingMode: Image.ResizingMode)
    case resizable3(capInsets: EdgeInsets, resizingMode: Image.ResizingMode)
    
    static let baseName = "resizable"
    
    init(syntax: FunctionCallExprSyntax) throws {
        let args = syntax.arguments
        
        if args.isEmpty {
            self = .resizable0
            return
        }
        
        var capInsets: EdgeInsets?
        var resizingMode: Image.ResizingMode?
        
        for arg in args {
            switch arg.label?.text {
            case "capInsets":
                capInsets = try EdgeInsets(syntax: arg.expression)
            case "resizingMode":
                resizingMode = try Image.ResizingMode(syntax: arg.expression)
            default:
                break
            }
        }
        
        if let capInsets, let resizingMode {
            self = .resizable3(capInsets: capInsets, resizingMode: resizingMode)
        } else if let capInsets {
            self = .resizable1(capInsets: capInsets)
        } else if let resizingMode {
            self = .resizable2(resizingMode: resizingMode)
        } else {
            self = .resizable0
        }
    }
    
    func imageBody(content: SwiftUI.Image) -> SwiftUI.Image {
        switch self {
        case .resizable0:
            return content.resizable()
        case .resizable1(let capInsets):
            return content.resizable(capInsets: capInsets)
        case .resizable2(let resizingMode):
            return content.resizable(resizingMode: resizingMode)
        case .resizable3(let capInsets, let resizingMode):
            return content.resizable(capInsets: capInsets, resizingMode: resizingMode)
        }
    }
}
