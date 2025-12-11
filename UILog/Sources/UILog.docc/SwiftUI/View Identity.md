# View Identity

SwiftUI에서 Identity가 주는 영향

## Identity

UIKit에서는 뷰가 클래스 타입이니, 뷰가 할당된 주소가 뷰의 Identity를 가르킵니다. Structure로 구현된 SwiftUI 뷰는 별도의 Identity를 갖습니다. 

* Explicity Identity 
* Structural Identity

```swift
var body: some View {
    CustomView()
        .id(1)
}
```

이런 식으로 id modifier를 사용하거나, ForEach문에 id를 넘겨줘서 Identity를 할당할 수 있습니다. 

```swift
var body: some View {
    if trigger {
        CustomView()
    } else {
        CustomView() 
    }
}
``` 

id가 명시적으로 나타나지 않은 경우, 코드의 위치로 id 값을 갖습니다. 두개의 뷰는 동일한 선언을 갖지만 서로 다른 분기점에 선언됐으니 다른 id를 갖게 됩니다. 

부모 자식 관계, 분기 위치 등이 Structural Identity에 영향을 줍니다. 


## Identity의 영향

<doc:Model-data> 문서에서 Model data는 별도의 Persistent storage를 갖는다고 했습니다. 서로 다른 Identity는 다른 저장 공간을 갖고, 해당 공간이 필요없으면 삭제됩니다. 

```swift
var body: some View {
    if trigger {
        CustomView()
    } else {
        CustomView() 
    }
}
``` 

따라서 trigger가 `true` 일 때와 `false` 일 때 나타나는 뷰는 서로 다른 Persitent storage 공간을 갖게 됩니다. 둘은 서로 다른 Structural Identity를 갖기 때문입니다. 


## Identity와 Life Time

Identity가 유지되는 것은 뷰의 onAppear ~ onDisappear 시점까지입니다. 

CustomView가 한번 생성된 후, 분기점에 의해 사라지고 다시 생성되는 경우 이미 기존에 있던 Identity는 사라졌기 때문에 Persistent Storage도 제거 후 새로 생성됩니다.

따라서 기존 model data 값을 유지하지 않습니다. 

## Sample

<doc:RerenderView>

## Reference

* [Demystify SwiftUI](https://developer.apple.com/kr/videos/play/wwdc2021/10022/)

