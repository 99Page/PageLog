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
/// # Peer: 매크로가 추가된 곳 외부에 새로운 무엇인가를 만드는 용도
///
/// ```
/// @Preview
/// struct CustomView: View {
///     var body: some View {
///         Text("1")
///     }
/// }
/// ```
///
/// 이게 확장되면
///
/// ```
/// struct CustomView: View {
///     var body: some View {
///         Text("1")
///     }
/// }
///
/// #Preview {
///     CustomView()
/// }
/// ```
///
/// 이런 느낌. member, memberAttribute는 선언된 곳 내부를 바꾸는 반면, 저거는 선언된 곳 외부에 추가
///
///
/// # accessor: stored property에 get/set/didSet/willSet 등을 추가하는 용도
///
/// # memberAttribute: 이미 정의된 것에 덧붙여 쓴다는 느낌
///
/// ```
/// @Discardable
/// struct Calculator {
///     func add(a: Int, b: Int) { a + b }
///     func minus(a: Int, b: Int) { a - b }
/// }
/// ```
/// 이게 확장되면 이렇게 바꿀 수 있음
///
/// ```
/// struct Calculator {
///     @discardableResult func add(a: Int, b: Int) { a + b }
///     @discardableResult func minus(a: Int, b: Int) { a - b }
/// }
/// ```
///
/// # member: 새로운 것들 추가함
///
/// ```
/// @DiscardableAddition
/// struct Calculator {
/// }
/// ```
///
/// 이게 확장되면
///
/// ```
/// struct Caculator {
///     @discardableResult func add(a: Int, b: Int) { a + b }
/// }

/// name specifiers
/// * overloaded
/// * prefixed
/// * suffixed
/// * named
/// * arbirary

@attached(member)
public macro View() = #externalMacro(module: "MyMacroMacros", type: "ViewMacro")

@attached(extension, conformances: CoreView)
public macro CoreView() = #externalMacro(module: "MyMacroMacros", type: "CoreViewMacro")

public protocol CoreView {
    associatedtype T: CoreView
    var body: T { get }
}
