# Concurrency Code


## Overview

스위프트는 비동기적으로 병렬적인 코드를 구조적으로 작성할 수 있도록 지원합니다. 

비동기적 코드를 통해 작업을 일시중단하거나 재실행할 수 있고,
이를 통해 오랜 시간이 걸리는 네트워크 요청이나 파일 파싱 같은 작업을 하면서도 UI 업데이트가 간으합니다. 

병렬적인 코드는 여러 코드가 동시에 실행되는 것을 말합니다. CPU가 4개의 코어를 갖는4개의 작업을 동시에 진행할 수 있습니다.

 > Note:
 Swift의 동시성 모델엔 쓰레드 위에 구축되어 개발자가 직접 쓰레드를 다루지 않습니다.
 비동기 함수는 쓰레드를 포기할 수 있고, 다른 쓰레드에서 실행될 수도 있습니다.
 **Continuation**이라는 작업 단위가 나뉘고 이 Continuation이 쓰레드 내부실행됩니다. 
자세한 내용은 WWDC에서 확인할 수 있습니다. 

## async await 예제

비동기를 순차적으로 실행하고 싶으면 이렇게 합니다. 

```swift 

let handle = FileHandle.standardInput
for try await line in handle.bytes.lines {
    print(line)
}

```

비동기를 병렬적으로 실행하고 싶으면 이렇게 합니다. 

```swift 
async let firstPhoto = downloadPhoto(named: photoNames[0])
async let secondPhoto = downloadPhoto(named: photoNames[1])
async let thirdPhoto = downloadPhoto(named: photoNames[2])


let photos = await [firstPhoto, secondPhoto, thirdPhoto]
show(photos)
```


## Tasks and Task Groups 

모든 비동기 코드는 Task에 속해서 실행됩니다. async let 같은 경우는, 암시적으로 child task를 만들어서 사용하고 있습니다. 명시적으로 chidl task를 추가하려면 TaskGroup을 사용하면 됩니다. 이렇게 한다면, 우선순위나 cancellataion 제어에 용이합니다.

TaskGroup 내의 Task는 동일한 parent task를 갖고, 각 task는 child task를 갖을 수 있습니다. task, task group 사이의 관계가 있어서 이런 방식을 **structured concurrency** 라고 부르며 이는 다음과 같은 장점을 갖습니다.  

- parent task의 관점에서, child task가 완료되는 것을 잊을 수가 없습니다. 
- child task의 우선 순위가 높아지면 parent task도 자동으로 적용됩니다.
- parent task가 취소되면, child task도 취소됩니다.
- Task-local 값이 효율적이면서도, 자동으로 child task에 전파됩니다.  

```swift
await withTaskGroup(of: Data.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        group.addTask {
            return await downloadPhoto(named: name)
        }
    }


    for await photo in group {
        show(photo)
    }
}
```

위 코드는 async let으로 작성한 코드를 TaskGroup으로 변환한 것입니다. 각 작업을 child task로 만들어 그룹에 추가했습니다. 각 child task가 완료되는 순서는 보장하지 않습니다.

> 에러를 반환해야할 경우 ``withThrowingTaskGroup(of: returning: body)``를 사용하면 됩니다. 

## Task Cancellation

각 Task는 실행될 때 적절한 시점에서 cancel 되었는지 확인해야합니다. 그리고 이에 대한 처리를 해야하는데 보통 아래 세가지 방식 중 하나를 사용합니다.  

- CancellationError 반환 
- nil이나 빈 배열 반환 
- 작업이 처리되지 않은 상태로 반환

작업이 취소됐는지 확인하는 방법은 두가지가 있습니다.
- Task.checkCancellation(): 취소됐는지 확인하고 에러를 반환합니다. 
- Task.isCancelled: 취소 유무만 확인하고 이후 처리는 개발자가 해야합니다. 

```swift
let photos = await withTaskGroup(of: Optional<Data>.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        let added = group.addTaskUnlessCancelled {
            guard !Task.isCancelled else { return nil }
            return await downloadPhoto(named: name)
        }
        guard added else { break }
    }


    var results: [Data] = []
    for await photo in group {
        if let photo { results.append(photo) }
    }
    return results
}
```

위 코드는 TaskGroup에서 더 개선한 코드입니다. 다음 변경 사항이 있습니다. 

- `TaskGroup.addTaskUnlessCancelled(priority: operation:)`을 사용해 cancellation 이후 새 작업이 추가되는 것을 방지합니다. 
- `addTaskUnlessCancelled(priority: operation:)` 이후 새로운 child task가 추가됐는지 확인합니다. group이 취소된 경우 이 값은 false가 되며 추가적인 사진을 다운로드 하지 않습니다. 
- 각 task는 사진을 다운로드 하기 전 취소됐는지 확인합니다. 취소됐다면 nil을 반환합니다. 
- 결과값을 반한할 때 nil인 값은 제외합니다. 취소된 task가 nil을 반환한다면, 완료된 task를 버리지 않고 반환할 수 있습니다.

`Task.withTaskCancellationHandler(operation:onCancel:isolation:)`을 사용하면 cancellation을 즉시 처리할 수 있습니다. 



## References

- [Swift 공식 문서](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)

