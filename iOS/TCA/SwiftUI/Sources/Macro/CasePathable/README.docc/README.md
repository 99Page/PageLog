# CasePathable

CasePathable 매크로에 대해서 정리한 문서

## Overview

초기 TCA는 Scope을 하기 위해서 이런 문법을 사용했다. 

```swift
store.scope(\.state, /Action.action)
```

struct에 있는 값은, KeyPath 문법으로 사용할 수 있었지만 enum에 있는 case는 KeyPath 문법으로 접근할 수 가 없었다. CasePathable 매크로는 enum에 있는 Case는 KeyPath 문법으로 접근할 수 있도록 해준다. 



![MacroExpand](MacroExpand)

지금은 Scope를 해줄 때 바로 KeyPath를 사용해서 접근할 수 있는데 이건, ObservableState 매크로가 Action에 자동으로 CasePathable을 추가해주기 때문이다. 
