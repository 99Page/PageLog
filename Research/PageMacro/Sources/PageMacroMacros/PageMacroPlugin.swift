//
//  PageMacroPlugin.swift
//  
//
//  Created by 노우영 on 8/5/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct PageMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        UnwrapReturnMacro.self
    ]
}
