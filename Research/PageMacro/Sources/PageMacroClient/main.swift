import PageMacro

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

func tryUnwrap() throws -> String {
    let hello: String? = "hello"
    
    /// 개발하다보면 guard문때문에 코드가 난잡해지는 경우가 많아서 매크로로 간단히 나타내보려고 했는데
    /// 그냥 guard문 쓰는게 훨씬 보기 편하다.
    /// guard문으로 난잡해지는 이유는
    /// 그냥 guard문이 많기때문인거 같다. 
    let unwrapped = try #unwrapReturn(value: hello, error: MyError.base).get()
    
    guard let unwrapped2 = hello else { throw MyError.base}
    return unwrapped
}

enum MyError: Error {
    case base
}
