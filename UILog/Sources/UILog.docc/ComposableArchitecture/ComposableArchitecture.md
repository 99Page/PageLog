# ComposableArchitecture

Composable Archictecture에 대한 개요를 작성한 문서 

## Overview

### 단방향 아키텍처

Composable Archicture는 단방향 아키텍처입니다. 어느 지점에서 값이 변경되는지 추적할 수 있는 이점을 갖습니다. 

```swift
@Reducer
struct Feature {
  @ObservableState
  struct State: Equatable { /* ... */ }
  enum Action { /* ... */ }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        return .none

      case .incrementButtonTapped:
        state.count += 1
        return .none
      }
    }
  }
}
```
위 코드를 보면, Store가 갖는 상태는 Action과 State를 처리한 Reducer 내부에서 처리됩니다. Action을 통해서만 State 변경이 가능해진다는 것은, 각 State를 변경시킨 원인을 찾을 수 있다는 것입니다. 

```swift
button.tapPublisher
    .sink { [weak viewModel] _ in
        viewModel?.count += 1   // 👈 여기서 직접 변경
    }
    .store(in: &cancellables)

Timer.publish(...)
    .sink { [weak viewModel] _ in
        viewModel?.count += 1   // 👈 또 다른 변경
    }
    .store(in: &cancellables)
```

단방향 아키텍처로 구성되지 않을 경우, 동시에 값이 변경되었을 때 그 원인을 추적하지가 어렵습니다. count를 증가시킨 것이 Timer에 의한 것인지, Button에 의한 것인지 알기 어렵습니다. 

따라서 TCA는 디버깅에 매우 유리한 아키텍처입니다.
