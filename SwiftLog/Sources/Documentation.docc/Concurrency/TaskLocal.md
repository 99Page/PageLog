# TaskLocal

`@TaskLocal` 에 대해서 정리한 문서


## Overview

TaskLocal, 즉 Task 지역 안에서 다루는 값을 뜻합니다. 동일한 비동기 영역 안에서 공유되는 값입니다.

```swift 
func read() -> String {
    if let value = Self.traceID {
        "\(value)" 
    } else { 
        "<no value>"
    }
}


TaskLocal의 값을 바인딩할 때는 항상 $traceID.withValue()를 사용해야합니다.
await Example.$traceID.withValue(1234) { // 

  read() // traceID: 1234. 동일한 비동기 영역입니다. 


  async let id = read() // async let child task, traceID: 1234. 하위 태스크이므로 동일한 비동기 영역입니다. 


  await withTaskGroup(of: String.self) { group in 
      group.addTask { read() } // task group child task, traceID: 1234
      return await group.next()!
  }


  Task { // Task 선언이 부모 태스트로부터 상속 받습니다. 
    read() // traceID: 1234
  }


  Task.detached { // detached는 부모 태스크에서 상속 받지 않습니다. 따라서 설정된 값이 없습니다.
    read() // traceID: nil
  }
}

// 여기서 선언하면 그냥 글로벌하게 접근할 수 있습니다. 
@TaskLocal
var contextualNumber: Int = 12
```


