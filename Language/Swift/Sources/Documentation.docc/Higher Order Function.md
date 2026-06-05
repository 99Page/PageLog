# Higher Order Function

## Overview

고차 함수(Higher Order Function)은 아래 두 가지 조건 중 하나 이상을 만족하는, 함수를 다루는 함수를 뜻합니다. 

* 다른 함수를 인자로 받는 함수 
* 함수의 실행 결과로 함수를 반환하는 함수 

Swift는 함수를 First-class Citizen으로 취급해 고차 함수의 특성을 갖습니다. 

Array에서 filter나 map이 고차 함수의 예시입니다. 

```swift
let numbers = [1, 2, 3, 4, 5]

let doubled = numbers.map { $0 * 2 } 

let evens = numbers.filter { $0 % 2 == 0 }
```

## 사용하는 이유 

Strategy Pattern을 사용해서 위 코드들을 표현할 수 있겠지만 로직을 생성하고 주입하는 것이 고차 함수를 다루는 것보다 복잡합니다. 

하나의 함수를 내부 로직을 변경해 다양하게 사용하는데는 고차 함수가 적합합니다. 
