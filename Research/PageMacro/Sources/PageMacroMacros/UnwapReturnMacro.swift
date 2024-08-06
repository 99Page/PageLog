//
//  File.swift
//
//
//  Created by 노우영 on 8/5/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UnwrapReturnMacro: ExpressionMacro {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let argumentList = node.argumentList
        guard let valueArgument = argumentList.first?.expression else { fatalError("argument가 부족합니다.") }
        let dropped = argumentList.dropFirst()
        guard let errorArgument = dropped.first?.expression else { fatalError("argument가 부족합니다.")}
        
        let expression = valueArgument
            .as(DeclReferenceExprSyntax.self)
        
        
        
        guard let expression else { fatalError("DeclReferenceExprSyntax로 캐스팅되지 않았습니다.") }
        
        return """
            { [\(expression)] in 
            guard let unwrapped = \(expression) else { return .failure(\(errorArgument)) }
            return .success(unwrapped)
            }()
            """
    }
}

