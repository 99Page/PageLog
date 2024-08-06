////
////  File.swift
////  
////
////  Created by 노우영 on 8/6/24.
////
//import SwiftCompilerPlugin
//import SwiftSyntax
//import SwiftSyntaxBuilder
//import SwiftSyntaxMacros
//
//public struct OptionalThrowMacro: PeerMacro {
//    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
//        guard let argument = node.argument. else {
//           fatalError("compiler bug: the macro does not have any arguments")
//       }
//    }
//    
////    public static func expansion(
////        of node: some FreestandingMacroExpansionSyntax,
////        in context: some MacroExpansionContext
////    ) -> ExprSyntax {
////        
////        
////        guard let argument = node.argumentList.first?.expression else {
////            fatalError("compiler bug: the macro does not have any arguments")
////        }
////        
////        return "(\(argument), \(literal: argument.description))"
////    }
//}
