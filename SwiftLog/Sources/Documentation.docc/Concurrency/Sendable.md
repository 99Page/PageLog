# Sendable

Sendable에 대해서 정리한 문서

## Overview

Sendable 말 그대로 보낼 수 있다는 뜻입니다. 어디에, 무엇을 보낼 수 있는지가 중요합니다.

* cocurrency domain에 
* 이 타입을 보낼 수 있다

라는 뜻으로 해석할 수 있습니다.

---
우선 Concurrency domain의 정의를 알아야합니다. Cocurreny domain 정의는 이렇습니다.

* mutable state를 갖는 프로그램의 일부분(Task, Actor)

그리고 Sendable은 concurrency 영역에서 사용되더라도 data race 같은 문제가 생기지 않는다는 것을 컴파일러에게 알려주는 역할을 합니다.

## Sendable 조건 

아래 3가지 조건 중 하나를 충족하면 Sendable을 채택할 수 있습니다. 

1. 내부 타입이 모두 Sendable한 Struct 타입
2. 내부 프로퍼티가 모두 immutable한 Class 타입
3. @MainActor 선언이나 프로퍼티 변경을 직렬화해서 내부적으로 안정성을 보장하는 타입. 

## Public

`Because TemperatureReading is a structure that has only sendable properties, and the structure isn’t marked public or @usableFromInline, it’s implicitly sendable.`


공식 문서에는 저런 문구가 있습니다. public으로 선언된 경우에는 암시적으로 Sendable하지 않고 반드시 개발자가 Sendable을 보장해줘야 합니다. 


## References

- [The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency)
