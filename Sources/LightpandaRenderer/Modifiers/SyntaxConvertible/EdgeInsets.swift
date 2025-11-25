//
//  EdgeInsets.swift
//  LightpandaClient
//
//  Created by Carson.Katri on 11/25/25.
//

import SwiftUI
import SwiftSyntax

extension EdgeInsets: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let call = syntax.as(FunctionCallExprSyntax.self),
              let top = call.argument(named: "top").flatMap(CGFloat.init(syntax:)),
              let leading = call.argument(named: "leading").flatMap(CGFloat.init(syntax:)),
              let bottom = call.argument(named: "bottom").flatMap(CGFloat.init(syntax:)),
              let trailing = call.argument(named: "trailing").flatMap(CGFloat.init(syntax:))
        else { return nil }
        self.init(
            top: top,
            leading: leading,
            bottom: bottom,
            trailing: trailing
        )
    }
}
