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

## ARC

자바는 클래스 타입을 사용할 때, 스택에는 힙 객체의 참조(주소) 가 저장되고, 실제 데이터는 힙(heap) 에 저장됩니다. 그리고 불필요해진 객체는 런타임 중에 Garbage Collector(GC) 가 힙 영역을 탐색하며 더 이상 참조되지 않는 객체를 찾아 자동으로 메모리를 해제합니다. 이 과정은 전체 힙을 스캔하거나 GC 루트를 따라 추적하는 방식으로 이루어집니다.

반면, Swift는 ARC 방식을 사용하여 메모리를 관리합니다. ARC는 컴파일 타임에 참조 카운트 증가 및 감소를 위한 코드를 삽입하고, 런타임에서는 참조 카운트가 0이 되는 시점에 메모리를 즉시 해제합니다. 이는 전체 힙을 주기적으로 스캔하는 방식보다 더 예측 가능하고 빠른 성능을 제공합니다. Swift는 이러한 메모리 관리 덕분에 오버헤드를 줄일 수 있습니다. 

Strong reference cycle는 다음 두가지 상황에 발생합니다. 

1. 서로 다른 Class 타입이 서로를 참조하고 있을 때 
2. Class 타입이 closure를 프로퍼티로 사용하고 있고, 이 closure가 클래스 내부의 프로퍼티를 capture하고 있을 떄

클로저 타입은 클래스처럼 Reference type입니다. 참조 되는 타입인 것을 유의해야합니다.  

```swift
class Person {
    var pet: Pet?
    deinit { print("Person deinitialized") }
}

class Pet {
    var owner: Person?
    deinit { print("Pet deinitialized") }
}

func createReferenceCycle() {
    let person = Person()
    let pet = Pet()

    person.pet = pet
    pet.owner = person
}

// 호출 후에도 Person과 Pet 모두 메모리에서 해제되지 않음 (순환 참조)
createReferenceCycle()

class ViewController {
    var title: String = "Main"
    
    var handler: (() -> Void)?
    
    func setupHandler() {
        handler = {
            print("Title is \(self.title)") // self를 strong하게 캡처
        }
    }
    
    deinit {
        print("ViewController deinitialized")
    }
}

func createClosureCycle() {
    let vc = ViewController()
    vc.setupHandler()
    
    // vc.handler는 vc를 참조하고 있고, vc는 handler를 프로퍼티로 가지고 있음 → 순환 참조
}

createClosureCycle()
```

위 코드는 Strong reference cycle이 발생하는 두가지 상황에 대한 예시입니다. 


## Reference

* [The Swift Programming Language (6.1)
Opaque and Boxed Protocol Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/opaquetypes/)
* [The Swift Programming Language (6.1)
Automatic Reference Counting](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting)
