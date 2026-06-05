# ComposableArchitecture: Effect

Composable Archictecture에서 Effect를 다루는 방법에 대해서 정리한 글

## Overview 

Composable Architeture 1.26.3 버전을 참고해서 작성한 문서입니다. 

## Core

TCA의 핵심 구성 요소는 4가지입니다. Store, Effect, Reducer, State 입니다. 뷰에서 Effect를 보내면 Reducer가 State를 변경 후 내부에서 Effect를 추가적으로 처리합니다. 그리고 Store는 나머지 세개를 모두 포함하는 객체입니다. 

실제 Effect는 어떻게 처리되고 있을까요? send를 보냈을 때 발생하는 일을 알아보겠습니다. 


Send를 보내면 이를 처리하는 것은 Core 객체입니다. Core는 Store처럼 여러 종류를 갖지만, Root Core를 기준으로 살펴보겠습니다. 

```swift
@MainActor
protocol Core<State, Action>: AnyObject, Sendable {
  associatedtype State
  associatedtype Action
  var state: State { get }
  func send(_ action: Action) -> Task<Void, Never>?

  var canStoreCacheChildren: Bool { get }
  var didSet: CurrentValueRelay<Void> { get }
  var isInvalid: Bool { get }

  var effectCancellables: [UUID: AnyCancellable] { get }
}
``` 

Store는 각기 다른 Store 간의 부모-자식 관계를 이어주는 것이 핵심이고 실제 로직의 처리는 Core에서 발생합니다. Reducer를 만들어 줄 때의 State, Action 값이 모두 Core의 assciatedType으로 있는 것을 확인할 수 있습니다. 뷰에서 `send(_ action: Action)` 으로 보낸 것도 이곳에서 처리 됩니다. 


```swift
private func _send(_ action: Root.Action) -> Task<Void, Never>? {
  self.bufferedActions.append(action)
  guard !self.isSending else { return nil }

  self.isSending = true
  var currentState = self.state
  let tasks = LockIsolated<[Task<Void, Never>]>([])
  defer {
    withExtendedLifetime(self.bufferedActions) {
      self.bufferedActions.removeAll()
    }
    self.state = currentState
    self.isSending = false
    if !self.bufferedActions.isEmpty {
      if let task = self.send(
        self.bufferedActions.removeLast()
      ) {
        tasks.withValue { $0.append(task) }
      }
    }
  }

  var index = self.bufferedActions.startIndex
  while index < self.bufferedActions.endIndex {
    defer { index += 1 }
    let action = self.bufferedActions[index]
    let effect = reducer.reduce(into: &currentState, action: action)
    let uuid = UUID()

    switch effect.operation {
    case .none:
      break
    case let .publisher(publisher):
      var didComplete = false
      let boxedTask = Box<Task<Void, Never>?>(wrappedValue: nil)
      let effectCancellable = withEscapedDependencies { continuation in
        publisher
          .receive(on: UIScheduler.shared)
          .handleEvents(receiveCancel: { [weak self] in self?.effectCancellables[uuid] = nil })
          .sink(
            receiveCompletion: { [weak self] _ in
              boxedTask.wrappedValue?.cancel()
              didComplete = true
              self?.effectCancellables[uuid] = nil
            },
            receiveValue: { [weak self] effectAction in
              guard let self else { return }
              if let task = continuation.yield({
                self.send(effectAction)
              }) {
                tasks.withValue { $0.append(task) }
              }
            }
          )
      }

      if !didComplete {
        let task = Task<Void, Never> { @MainActor in
          for await _ in AsyncStream<Void>.never {}
          effectCancellable.cancel()
        }
        boxedTask.wrappedValue = task
        tasks.withValue { $0.append(task) }
        self.effectCancellables[uuid] = AnyCancellable { @Sendable in
          task.cancel()
        }
      }
    case let .run(name, priority, operation):
      withEscapedDependencies { continuation in
        let task = Task(name: name, priority: priority) { @MainActor [weak self] in
          let isCompleted = LockIsolated(false)
          defer { isCompleted.setValue(true) }
          await operation(
            Send { effectAction in
              if isCompleted.value {
                reportIssue(
                  """
                  An action was sent from a completed effect.

                    Action:
                      \(debugCaseOutput(effectAction))

                    Effect returned from:
                      \(debugCaseOutput(action))

                  Avoid sending actions using the 'send' argument from 'Effect.run' after \
                  the effect has completed. This can happen if you escape the 'send' \
                  argument in an unstructured context.

                  To fix this, make sure that your 'run' closure does not return until \
                  you're done calling 'send'.
                  """
                )
              }
              if let task = continuation.yield({
                self?.send(effectAction)
              }) {
                tasks.withValue { $0.append(task) }
              }
            }
          )
          self?.effectCancellables[uuid] = nil
        }
        tasks.withValue { $0.append(task) }
        self.effectCancellables[uuid] = AnyCancellable { @Sendable in
          task.cancel()
        }
      }
    }
  }

  guard !tasks.isEmpty else { return nil }
  return Task { @MainActor in
    await withTaskCancellationHandler {
      var index = tasks.startIndex
      while index < tasks.endIndex {
        defer { index += 1 }
        await tasks[index].value
      }
    } onCancel: {
      var index = tasks.startIndex
      while index < tasks.endIndex {
        defer { index += 1 }
        tasks[index].cancel()
      }
    }
  }
}
```

실제 send를 했을 때 실행되는 코드입니다. reducer를 사용해서 상태를 변경하는 것이 보입니다. 그리고 switch문을 사용해 반환하는 Effect가 Combine인지 Task인지 구분해서 별도로 처리하고, 계속 더이상 반환하는 effect가 없을 때까지 재귀적으로 send를 호출합니다. 

effect가 들어오면 큐에 쌓으면 될 것 같은데 배열을 사용해서 처리하는 것이 눈에 띕니다. 큐는 메모리에 불연속적으로 쌓이고, 포인터를 이용한 추가적인 오버헤드가 발생합니다. 반면 배열을 사용하면 메모리에 연속적으로 쌓이기 때문에 랜덤하게 접근 가능해서 효율적입니다. Action은 적은 양이 쌓이기때문에 큐를 사용하는 것보다는 인덱스를 관리해주는게 효율적이었다고 판단합니다.


