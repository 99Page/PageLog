import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct CoreViewMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let name = declaration.as(ClassDeclSyntax.self)!.name
        
        return [
            try ExtensionDeclSyntax(
                """
                extension \(name): CoreView {
                }
                """
            )
        ]
    }
}
