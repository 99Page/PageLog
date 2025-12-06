# Equatable


## Overview

두 타입이 동일한 값을 갖는지 확인하고 싶을 때는 `==` 연산 혹은 `!=` 연산을 사용한다. 이 연산을 사용하려면 `Equatable` 프로토콜을 채택해야한다. 

`Equatable`을 채택하고 `==` 함수를 정의하면 `==` 연산을 사용할 수 있다. 

```swift
static func == (lhs: Type, rhs: Type) -> Bool {
   return
       lhs.value == rhs.value &&
       lhs.name == rhs.name
}
``` 

하지만 아래 조건들에서는 `Equatable`이 자동으로 정의된다. 

* 프로퍼티가 모두 Equatable한 struct

* associated value가 모두 Equtable한 enum 

## 참조 비교 연산

== 연산은 내부 값을 비교하기 위한 것으로, 클래스의 참조가 같은지 확인하는 것과는 다르다. 참조를 비교하려면 `===` 연산을 사용해야한다. 

```swift
class Simple: Equtable {
    let v: Int

    static func == (lhs: Type, rhs: Type) -> Bool {
       return
           lhs.value == rhs.value &&
           lhs.name == rhs.name
    }
}
```

위 상황에서, 두개 연산을 각각 사용해보면 결과를 아래처럼 나온다. 

```swift
let first = Simple(v: 1)
let second = Simple(v: 1)

print(first == second) // true 
print(first === second) // false
```
