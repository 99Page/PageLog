# ObserverPattern

## Overview

Observer 패턴은 어떤 객체의 상태가 변하면, 그 변화를 미리 등록해둔 다른 객체들이 자동으로 통지받고 반응하도록 만드는 패턴입니다.

하나의 객체가 여러 객체에게 변화를 알려야 할 때 사용되며, 객체들끼리 직접 연결되지 않아도돼서 확장성이 좋아집니다. Swift에서는 NotificationCenter, Combine의 Publisher/Subscriber 구조가 대표적인 Observer 패턴의 예시입니다.

