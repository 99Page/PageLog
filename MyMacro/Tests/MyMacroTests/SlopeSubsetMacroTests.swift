//
//  Test.swift
//  MyMacro
//
//  Created by 노우영 on 8/19/25.
//

import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

final class SlopeSubsetMacroTests: XCTestCase {
    
    func testSubset() async throws {
        assertMacroExpansion(
            """
            @EnumSubset<Slope>
            enum EasySlope {
                case beginnersParadise
                case practiceRun
            }
            """,
            expandedSource:
            """
            enum EasySlope {
                case beginnersParadise
                case practiceRun
            
                init?(_ slope: Slope) {
                    switch slope {
                    case .beginnersParadise:
                        self = .beginnersParadise
                    case .practiceRun:
                        self = .practiceRun
                    default:
                        return nil
                    }
                }
            }
            """,
            macros: testMacros)
    }
    
    func testOnStruct() throws {
        assertMacroExpansion(
            """
            @EnumSubset<Slope>
            struct Skier {
            }
            """,
            expandedSource:
            """
            struct Skier {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "enum 타입에만 @SlopeSubset을 사용할 수 있어요", line: 1, column: 1)
            ],
            macros: testMacros)
    }
}
