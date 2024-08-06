import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PageMacroMacros)
import PageMacroMacros

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "unwrapResult": UnwrapReturnMacro.self
]
#endif

final class PageMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(PageMacroMacros)
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        let value: String? = "Haha"
#if canImport(PageMacroMacros)
assertMacroExpansion(
    """
    #unwrapResult(name: "unwrapped", value)
    """,
    expandedSource: """
    """,
    macros: testMacros
)
#else
throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
