//
//  Test.swift
//  TuistMacroTests
//
//  Created by 노우영 on 5/30/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing
import TuistMacroMacros

struct Test {
    
    @Test
    func testMacroWithStringLiteral() throws {
#if canImport(TuistMacroMacros)
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: [:]
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
