//
//  File.swift
//  MyMacro
//
//  Created by 노우영 on 8/19/25.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum SlopeSubsetError: CustomStringConvertible, Error {
    case onlyAppliableToEnum
    
    var description: String {
        switch self  {
        case .onlyAppliableToEnum:
            "enum 타입에만 @SlopeSubset을 사용할 수 있어요"
        }
    }
}

public struct SlopeSubsetMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext // 컴파일러와 통신하는 내용
    ) throws -> [DeclSyntax] {
        // 주어진 타입이 Enum인지 확인
        // po enumDecl 명령어로 디버깅 가능
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw SlopeSubsetError.onlyAppliableToEnum
        }
        
        guard let superSetType = node
            .attributeName.as(IdentifierTypeSyntax.self)?
            .genericArgumentClause?
            .arguments.first?
            .argument else {
            return []
        }
        
        let members = enumDecl.memberBlock.members
        let caseDecl = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let elements = caseDecl.flatMap { $0.elements }
        
        // SwifySyntax 문서 참조해서 새로운 선언 만들기
        let initializer = try InitializerDeclSyntax("init?(_ slope: \(superSetType))") {
            try SwitchExprSyntax("switch slope") {
                for element in elements {
                    SwitchCaseSyntax(
                        """
                        case .\(element.name):
                            self = .\(element.name)
                        """
                    )
                }
                SwitchCaseSyntax("default: return nil")
            }
        }
        
        return [DeclSyntax(initializer)]
    }
}
