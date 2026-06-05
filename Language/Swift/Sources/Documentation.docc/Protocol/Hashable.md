# Hashable

## Overview

어떤 타입을 Set, Dictionary의 키값에 사용하려면 `Hashable` 프로토콜을 채택해야한다. `Hashable`을 채택할 타입은 우선 `Equatable`을 채택 되어야 한다. 

두 값이 Equatable 하다면 두 값에서 나오는 `hashValue`는 동일하다는 것에 주의해야한다. 

`Hashable`을 사용하려면, 아래 함수를 정의해야한다. 

```swift
func hash(into hasher: inout Hasher) {
   hasher.combine(value)
   hasher.combine(name)
}
``` 

아래 조건에서는 `hash` 함수를 별도로 정의할 필요가 없다. 

* 내부 프로퍼티가 모두 Hashable을 채택한 struct
* associated value가 모두 Hashable을 채택한 enum 


