# README

NavigationStack을 사용할 때 동일한 Store에 다른 의존성을 주입하는 방법에 대해서 정리한 폴더입니다. 

## R&D

[Migrating to 1.8](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.8/) 이후 `@Reducer` 매크로만을 사용해서 간단하게 네비게이션을 처리할 수 있게 됐습니다.

```swift
@Reducer
struct Destination {
  @ObservableState
  enum State {
    case add(FormFeature.State)
    case detail(DetailFeature.State)
    case edit(EditFeature.State)
  }
  enum Action {
    case add(FormFeature.Action)
    case detail(DetailFeature.Action)
    case edit(EditFeature.Action)  
  }
  var body: some ReducerOf<Self> {
    Scope(state: \.add, action: \.add) {
      FormFeature()
    }
    Scope(state: \.detail, action: \.detail) {
      DetailFeature()
    }
    Scope(state: \.edit, action: \.edit) {
      EditFeature()
    }
  }
}
```

기존에는 위의 방식으로 작성해야됐던 코드가 이 버전 이후 아래처럼 간단히 변경되었습니다.

```swift
@Reducer
enum Destination {
  case add(FormFeature)
  case detail(DetailFeature)
  case edit(EditFeature) 
}
```

간단해진만큼 Scope를 사용해 의존성 주입이 불가능해졌습니다. 따라서 의존성 주입이 필요하다면, 구 버전의 API를 사용하면 됩니다.

