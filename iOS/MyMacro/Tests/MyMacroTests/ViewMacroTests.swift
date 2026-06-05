//
//  ViewMacroTests.swift
//  MyMacro
//
//  Created by 노우영 on 8/19/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest


final class ViewMacroTests: XCTestCase {
    func testOnlyStack() async throws {
        assertMacroExpansion(
            """
            @View
            class CustomView: UIViewController {
                var body: some CoreView {
                    VStack("stack") {
                    }
                }
            }
            """,
            expandedSource:
            """
            class CustomView: UIViewController {
                var body: some CoreView {
                    VStack("stack") {
                    }
                }
            
                var stack = VStack()
            }
            """,
            macros: testMacros
        )
    }
    
    func testStackHasChild() async throws {
        assertMacroExpansion(
            """
            @View
            class CustomView: UIViewController {
                var body: some CoreView {
                    VStack("stack") {
                        Text("title")
                
                        Text("description")
                    }
                }
            }
            """,
            expandedSource:
            """
            class CustomView: UIViewController {
                var body: some CoreView {
                    VStack("stack") {
                        Text("title")
                
                        Text("description")
                    }
                }
            
                var stack = VStack()
            
                var title = Text()
            
                var description = Text()
            }
            """,
            macros: testMacros
        )
    }
    
    func test3Depth() {
        assertMacroExpansion(
            """
            @View
            class CustomView: UIViewController {
                var body: some CoreView {
                    VStack("stack") {
                        Text("title")
                
                        HStack("creator") {
                            Text("name")
            
                            Text("rank")
                        }
                    }
                }
            }
            """,
            expandedSource:
            """
            class CustomView: UIViewController {
                var body: some CoreView {
                    VStack("stack") {
                        Text("title")
                
                        HStack("creator") {
                            Text("name")

                            Text("rank")
                        }
                    }
                }

                var stack = VStack()

                var title = Text()

                var creator = HStack()

                var name = Text()

                var rank = Text()
            }
            """,
            macros: testMacros)
    }
}
