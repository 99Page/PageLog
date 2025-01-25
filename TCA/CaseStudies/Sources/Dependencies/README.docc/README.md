# ``CaseStudies-TCA``

Point-free의 Dependencies에 대해서 정리한 글

## Dependency Injection

어플을 개발하다 보면 앱 내부에서 제어할 수 없는 외부 시스템을 사용하는 상황이 많습니다. 서버에서 데이터를 가져오기 위해 API를 호출하는 경우가 대표적입니다. 이러한 외부 시스템과의 연동은 의존성 주입을 통해 관리하는 것이 일반적이며, 의존성 주입은 다음과 같은 이점을 제공합니다:

1. 빌드 타임 단축
외부 시스템을 직접 호출하면 빌드 과정에서 의존성이 생겨 빌드 시간이 늘어납니다. 하지만, 개발자가 미리 정의한 값을 반환하도록 설계하면 이러한 의존성으로 인한 빌드 시간을 줄일 수 있습니다.

2. 테스트 용이성
외부 시스템에서 반환되는 데이터는 예측할 수 없는 경우가 많아 테스트에 적합하지 않을 수 있습니다. 하지만 미리 정의된 값을 사용하면 다양한 테스트 시나리오를 쉽게 구현할 수 있습니다. 

애플 커뮤니티에서는 의존성 주입 시 Protocol을 사용하는 방법을 추천합니다.
프로토콜을 활용하면 함수 시그니처를 통해 의존성을 정의할 수 있고, 이를 기반으로 다양한 상황에 맞는 타입을 구현할 수 있습니다. 

```
protocol SomeClient {
    func read() -> String
}

struct PageClient: SomeClient {
    func read() { "Page" }
}

struct AppleClinet: SomeClient {
    func read() { "Apple" }
}
```

이러한 방식에는 단점이 있습니다. 케이스별로 타입을 하나씩 정의해야 하므로, 관리가 복잡하고 번거로울 수 있습니다. 


```
struct MockClientt: SomeClient {
    var _read: String 
    func read() { _read }
}

let pageMock = MockClient {
    _read: { "Page" }
}

let appleMock = MockClient {
    _read: { "Apple" }
}
```

Point-Free는 위 문제를 해결하기 위해 클로저를 활용한 Mock 타입을 제안합니다. 프로토콜의 메서드를 클로저로 대체할 수 있도록 설계하면, 단 하나의 타입으로 다양한 케이스를 처리할 수 있습니다. 


## References

 [Ep#110 Designing Dependencies: The Problem](https://www.pointfree.co/collections/dependencies/designing-dependencies/ep110-designing-dependencies-the-problem)
