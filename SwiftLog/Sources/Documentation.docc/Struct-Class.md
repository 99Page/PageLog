# Struct, Class


## Struct 

### Copy on write

Value type으로 구성되고, 용량이 큰 배열을 복사한다고 가정하겠습니다.

```swift
let a: [BigData] = [] // 배열 내부에 큰 값이 있다고 가정 
var b = a 
```

Value type을 복사하는 것이니 a가 가진 값들을 그대로 복제하게 됩니다. 하지만 이렇게 할 경우 저장 공간이 낭비됩니다. Swift는 copy on write를 사용하기 때문에 커다란 값에 대해서는 연산 시점에서 값을 복사하지 않습니다. 

```swift
var b = a // 동일한 주소 참조 
b[0] = BigData() // 이 때 값을 복사 
```

기존과 다른 값을 사용하게 될 때, 즉 새로운 값으로 덮어쓸 때 값을 복사합니다.

## Class

### ARC

자바는 클래스 타입을 사용할 때, 스택에는 힙 객체의 참조(주소) 가 저장되고, 실제 데이터는 힙(heap) 에 저장됩니다. 그리고 불필요해진 객체는 런타임 중에 Garbage Collector(GC) 가 힙 영역을 탐색하며 더 이상 참조되지 않는 객체를 찾아 자동으로 메모리를 해제합니다. 이 과정은 전체 힙을 스캔하거나 GC 루트를 따라 추적하는 방식으로 이루어집니다.

반면, Swift는 ARC 방식을 사용하여 메모리를 관리합니다. ARC는 컴파일 타임에 참조 카운트 증가 및 감소를 위한 코드를 삽입하고, 런타임에서는 참조 카운트가 0이 되는 시점에 메모리를 즉시 해제합니다. 이는 전체 힙을 주기적으로 스캔하는 방식보다 더 예측 가능하고 빠른 성능을 제공합니다. Swift는 이러한 메모리 관리 덕분에 오버헤드를 줄일 수 있습니다. 

Strong reference cycle는 다음 두가지 상황에 발생합니다. 

1. 서로 다른 Class 타입이 서로를 참조하고 있을 때 
2. Class 타입이 closure를 프로퍼티로 사용하고 있고, 이 closure가 클래스 내부의 프로퍼티를 capture하고 있을 때

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
