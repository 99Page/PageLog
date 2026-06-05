# Closure

클로저에 대한 내용을 정리한 문서

## 클로저란? 

클로저는 주변 값을 캡처해서 사용할 수 있는 코드 블록입니다. 


## Capture

```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
```

위 코드 예제를 살펴보겠습니다. 이 코드는 문제가 없습니다. 하지만 `incrementer()` 함수만 따로 보면 이상합니다.

```swift
func incrementer() -> Int {
    runningTotal += amount
    return runningTotal
}
```

runningTotal, amount는 incrementer의 parameter도 아니고, 내부에 선언된 값도 아닙니다. 이 두 값은 `makeIncrementer`에 정의되어 있습니다. 이런 값들이 캡처되는 값들입니다. 

한번 캡처된 값들은, 클로저가 사라질 때까지 그 값이 유지됩니다. 

```swift
let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen() // 10
incrementByTen() // 20
incrementByTen() // 30
```

클로저를 만들어서 세번 호출해보겠습니다. runningTotal의 초기값은 0이었습니다. 그러니 호출하면 매번 10이 되어야할거 같지만, incrementByTen이 갖고 있는 runningTotal 값은 계속 유지되고 있기 때문에 계속 증가합니다.

```swift
let incrementByTen = makeIncrementer(forIncrement: 10)
let incrementByOne = makeIncrementer(forIncrement: 1)

incrementByTen() // 10
incrementByOne() // 1
```

하지만 서로 다른 클로저는 독립적인 값을 캡처하고 있습니다. 위 케이스와는 달리 `incrementByOne`을 한번 호출했을 때, 초기값인 0에 값을 추가하고 있습니다. 두 개의 클로저는 서로 별도의 저장 공간을 갖기 때문입니다. 

## Reference type

```swift
let alsoIncrementByTen = incrementByTen

incrementByTen() // 10 
alsoIncrementByTen()  // 20 
```

클로저는 참조 타입입니다. 따라서 캡처된 값들을 동일하게 사용합니다. 위 코드에서, 별도의 클로저 변수를 따로 만든 후 실행한 결과 같은 runningTotal에 접근하고 있는 것을 알 수 있습니다. 

## Escaping

클로저를 전달받은 함수가 종료된 이후에도 사용한다면, `@escaping` 키워드를 사용해야합니다.

```swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```

위 코드처럼, 전달받은 클로저를 변수에 추가하는 경우 등이 해당합니다. 이 때, 참조 순환에 유의합니다. @escaping 클로저에서 self를 명시적으로 사용해야 하는 경우 reference count가 증가합니다.

```swift
class MyViewController {
    var handler: (() -> Void)?

    func setup() {
        handler = {
            // self를 그대로 사용 → self를 strong capture
            print(self.view.description)
        }
    }
}
```

print를 선언한 곳이 아니라 외부에서도 사용하는 상황이니 이는 escaping closure입니다. 또한 self를 명시적으로 사용해야하는 상황이고, reference count가 증가합니다. 스스로의 reference count가 증가했으니 참조 순환이 발생합니다. 

## Autoclosures


Autoclosure는 클로저를 전달할 때 내부 기능을 { } 로 자동으로 감싸줍니다.

```swift
func passClosure(_ condition: () -> Bool) {
    if condition() {
        print("True!")
    }
}

passClosure({ 2 > 1 })   // 호출할 때 { } 를 써야 함

func passAutoclosure(_ condition: @autoclosure() -> Bool) {
    if condition() {
        print("True!")
    }
}

pssClosure( 2 > 1 )   // 호출할 때 { } 필요없음. 
```

단, @autoclosure와 @escaping은 같이 쓰일 수 없습니다. 
