# README

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
struct SomeClient {
    var read: () -> String 
}

let pageMock = SomeClient {
    read: { "Page" }
}

let appleMock = SomeClient {
    read: { "Apple" }
}
```

이런 방식을 클로저 기반 설계라고 부르겠습니다. 

Point-Free는 위 문제를 해결하기 위해 클로저를 활용한 Mock 타입을 제안합니다. 프로토콜의 메서드를 클로저로 대체할 수 있도록 설계하면, 단 하나의 타입으로 다양한 케이스를 처리할 수 있습니다. 

## Modularization

Point-free에서는 이 방식을 사용해서 컴파일을 효율적으로 할 수 있는 방법도 제시합니다. 이 방법은 클로저 기반 설계에서만 가능한 방식은 아니고 프로토콜로도 충분히 가능한 방식입니다. 

API를 호출하기 위한 거대한 프레임워크, LargeFramework가 있다고 가정하겠습니다. 이 LargeFramework에 의존하는 기능이 변경되면 전체를 다시 컴파일 하면서 속도가 저하됩니다. Mock으로 사용할 기능을 변경해도 LargeFramework를 다시 컴파일해야합니다.

Point-free는 이 문제를 해결하기 위해 아래 방식으로 모듈화를 진행했습니다.

Project 
|--Feature
|   |--SomeClient
|
|--LiveClient
    |--SomeClient
    |--LargeFramework

개발하는 프로젝트는, 어떤 개별 기능을 구현한 Feature에 의존합니다. 이 Feature는 DI를 위한 클로저를 정의한 SomeClient에 의존합니다. 이런 설계를 통해서 Feature는 LargeFramework의 의존성을 제거할 수 있습니다. SomeClient에 정의된 클로저를 사용해서, Mock 데이터만 만들어 Feature의 기능을 확인할 수 있습니다. 

실제 프로젝트에서는 LargeFramework가 필요한데, 이 프레임워크에 의존하는 기능을 구현한 프레임워크를 LiveClient에 모듈화했습니다. LargeFramework 기능이 필요하면 LiveClient만 수정하면 됩니다. 


## 의문점 

* @Dependency를 사용함으로써 원하는 기능을 주입하기가 어려워졌는데 이는 어떤 것과 trade-off 관계가 있을까? 

*  struct를 사용함으로써 타입 캐스팅은 불가능해 졌는데 실제 프로덕트에서 타입 캐스팅을 사용할 상황은 별로 없나?

## 후기 

point-free가 ep 110 근처를 녹화할 때 쯤에는 async await이 도입되기 전이었나 보다. 


## References

 [Ep#110 Designing Dependencies: The Problem](https://www.pointfree.co/collections/dependencies/designing-dependencies/ep110-designing-dependencies-the-problem)

 [Ep#111 Designing Dependencies: Modularization](https://www.pointfree.co/collections/dependencies/designing-dependencies/ep111-designing-dependencies-modularization)

 [Ep#112 Designing Dependencies: Reachability](https://www.pointfree.co/collections/dependencies/designing-dependencies/ep112-designing-dependencies-reachability)

[Ep#113 Designing Dependencies: Core Location](https://www.pointfree.co/episodes/ep113-designing-dependencies-core-location)
