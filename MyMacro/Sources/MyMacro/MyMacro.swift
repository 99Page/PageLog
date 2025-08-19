// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "MyMacroMacros", type: "StringifyMacro")

@attached(member, names: named(init))
public macro EnumSubset<SuperSet>() = #externalMacro(module: "MyMacroMacros", type: "SlopeSubsetMacro")

/// attached 유형
///
/// * peer: 모든 선언(함수, 프로퍼티, computed property...)에 추가 가능. 이미 선언된 것과 비슷한 무언가를 만들 때 사용하는 느낌(추측)
/// * accessor: 변수와 아래첨자(get, set, willSet...) 등에 추가. getter, setter 만드는 용도같음
/// * memberAttribute: extension, type에 사용한다. 기존에 있던 멤버에 뭔가를 추가
/// * member: extension, type에 사용. 새로운 멤버를 추가하는 용도
/// * conformance: 프로토콜 추가 용도

/// name specifiers
/// * overloaded
/// * prefixed
/// * suffixed
/// * named
/// * arbirary

@attached(member)
public macro View() = #externalMacro(module: "MyMacroMacros", type: "ViewMacro")
