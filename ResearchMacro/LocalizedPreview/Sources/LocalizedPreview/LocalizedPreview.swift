// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "LocalizedPreviewMacros", type: "StringifyMacro")

@freestanding(declaration)
public macro localizedPreview<Content: View>(view: @escaping () -> Content) = #externalMacro(module: "LocalizedPreviewMacros", type: "LocalizedPreviewMacro")
