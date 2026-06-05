# ``SwiftLog/OpaqueType``

Opaque Type에 대해 정리한 문서

## Opqaue and Boxed Protocol Types

> Keyword: Protocol & associated type. Compiler. Type erasure. 

스위프트에서는 타입의 구체적인 사항은 opaque type, boxed protocol type 
두가지 방법으로 숨길 수 있습니다. 
모듈과 모듈을 호출하는 코드 사이에 타입 정보를 숨기면, 반환값의 실제 타입을 숨길 수 있어 유용합니다. 

opaque type을 반환하는 function이나 method는 반환되는 타입의 정보를 숨기고, 
프로토콜이 지원하는 내용을 제공합니다.
컴파일러는 opaque type의 type identity 알 수 있지만 모듈을 사용하는 클라이언트는 알 수 없습니다. 

boxed protocol은 프로토콜을 준수하는 모든 타입을 저장합니다. boxed protocol에서는 type identity를 보존하지 않습니다. 런타임 전에는 구체적인 타입을 알 수 없으며 저장될 타입을 계속 바꿀 수 없습니다.

### Opaque Type이 해결하려는 문제


모듈에 도형을 그리는 기능을 만드는 상황을 가정하겠습니다. shape가 가져야할 기본적인 기능은 `draw()`입니다. `Shape` 프로토콜에 이 사항을 정의할 수 있습니다. 


```swift
protocol Shape {
    func draw() -> String
}


struct Triangle: Shape {
    var size: Int
    func draw() -> String {
       var result: [String] = []
       for length in 1...size {
           result.append(String(repeating: "*", count: length))
       }
       return result.joined(separator: "\n")
    }
}
let smallTriangle = Triangle(size: 3)
print(smallTriangle.draw())
// 출력 예시: 
// *
// **
// ***
```

도형을 반대로 뒤집는 기능을 만들고 싶을 때는 제너릭을 사용할 수 있습니다. 
하지만 뒤집힌 결과를 생성할 때 사용한 제너릭 타입이 외부에 노출됩니다. 

```swift
struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}
let flippedTriangle = FlippedShape(shape: smallTriangle)
print(flippedTriangle.draw())
// 출력 예시: 
// ***
// **
// *
```

제너릭 타입을 사용하면, 사용하는 쪽에서도 어떤 타입을 사용하는지 알 수 있게 됩니다. 따라서 어떤 타입을 어떻게 사용했는지 고려해야되서 사용하기 어려워집니다. 

숨겨도 되는 것은 숨기는 것이 API를 개발하는데 필수적입니다. opaque type은 아래 상황에서 이점을 갖습니다. 

```swift 
let result: FlippedShape = filp(myShape)
```

FlippedShape라는 타입명이 바뀌면 외부의 코드들고 전부 고쳐야합니다. Shape로 표현했으면 수정하지 않아도 됩니다. 이런 이점은 SwiftUI의 View에서 확인할 수 있습니다. View의 body는 이런식으로 작성 됩니다.

```swift
var body: some View 
```

뷰를 바꾸게 되면 내부 뷰가 계속 바뀌게 됩니다. 계속 뭔가의 제너릭 뷰가 반복되고, 이것을 사용할 경우 뷰는 바꾸면 사용하는 쪽에서도 계속 타입을 바꿔야하니 코드를 작성하기 어려워집니다. some View를 사용하니 내부 뷰가 바뀌어도 구체적인 타입은 무시할 수 있게됩니다. 

``` swift 
let result: Shape = rotate(filp(myShape))
```

또한, Shape 타입만 반환해서 계속 조합을 할 수 있습니다. FlippedShape라는 구체적인 타입을 반환해줬다면 여기서 계속 연산을 하기가 어렵습니다. 

### Opaque type 반환

Opaque type은 `reverse of generic type` 으로 생각할 수 있습니다. 제너릭 타입은 함수 parameter나 반환 타입을 함수 선언부에서 작성합니다. 예를 들어서 max 연산이 그렇습니다.

```swift
func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }
```

이렇게 함수를 호출하는 쪽이 타입을 지정하게 됩니다. opaque type은 이와는 반대됩니다. 함수를 선언하는 쪽에서 반환할 타입을 결정하고 외부로는 타입을 숨깁니다. 호출하는 쪽에서는 프로토콜만 신경쓰면 됩니다. 

```swift
func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}
```

`makeTrapezoid()` 함수는 `some Shape`를 반환하고 있습니다. 

또한, Opaque 타입은 한가지 타입만 반환할 수 있습니다. 내부 분기를 통해 상황에 따라 다른 타입을 반환할 수 없습니다.
