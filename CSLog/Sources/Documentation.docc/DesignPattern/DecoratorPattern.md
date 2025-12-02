# DecoratorPattern

## Overview

Decorator 패턴은 객체의 기능을 동적으로 확장하기 위해
기존 객체를 감싸며 기능을 덧입히는 패턴입니다.
사용자가 기능을 연속적으로 쌓는 점에서 SwiftUI의 modifier와 비슷하지만,
SwiftUI는 value type 기반의 새로운 View 타입을 생성하는 방식이기 때문에
전통적인 객체지향 Decorator 패턴과 구현 구조는 다릅니다.
