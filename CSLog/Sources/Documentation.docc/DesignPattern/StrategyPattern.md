# StrategyPattern

## Overview

Strategy 패턴은 특정 기능을 프로토콜로 추상화하고,
상황에 따라 서로 다른 구현체를 주입해 동작을 유연하게 바꾸는 패턴입니다.
ViewModel에서 API 레이어를 추상화해 실제 API와 Mock API를 교체하거나,
로직을 테스트하기 위해 다른 객체를 주입하는 상황에서 가장 흔하게 사용됩니다.

