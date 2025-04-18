# Swift

스위프트에 대한 전반적인 내용을 정리한 문서

## Opqaue and Boxed Protocol Types

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
