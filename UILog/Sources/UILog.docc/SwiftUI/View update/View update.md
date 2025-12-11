# View update

SwiftUI에서 뷰 업데이트에 대한 내용을 정리합니다. 

## Overvew

![DependencyTree](DependencyTree)

선언한 뷰가 위 이미지처럼 Model data를 의존한다고 가정하겠습니다. 초록색 박스는 뷰의 상하 구조를 나타내고, 파란색 박스는 해당 뷰가 의존 중인 Model data들입니다. 

![DependencyGraph](DependencyGraph)

보기 쉽게 트리 모양을 그래프로 표시하면 이런 구조가 됩니다. <doc:Model-data>에서 값이 변경되면 뷰가 리렌더 된다고 했습니다. 그런데 모든 것을 리렌더하지는 않고, 각 뷰가 의존 중인 Model data의 변경에 대해서만 리렌더 됩니다.

## 업데이트 제한

```swift
struct Model {
    var value1 = 0
    var value2 = 0
    var value3 = 0
}

struct ParentView: View {
    @State var model = Model() 
    
    var body: some View {
        ChildView(model: model)
    }
}

struct ChildView: View {
    let model: Model
    
    var body: some View {
        Text("\(model.value1)")
    }
}
```

위 코드를 보면 ChildView의 body는 model.value1 한개에만 영향을 받는데, ParentView로부터 Model 타입 전체를 받아오고 있다.

이런 경우, value1이 아닌 다른 값들이 변경돼도 ChildView는 리렌더 된다. 따라서 업데이트 비용이 큰 경우에는 필요한 값만 받아오는거 이상적이다. 

하지만 뷰 자체에 필요한 값들이 많아지면, 이니셜라이저가 커지게 된다. 그러니까 뷰의 업데이트 비용 + 한개 타입으로 추상화 하는 비용을 잘 따져야한다. 


## Reference

* [Demystify SwiftUI](https://developer.apple.com/kr/videos/play/wwdc2021/10022/)

* [Demystify SwiftUI performance](https://developer.apple.com/kr/videos/play/wwdc2023/10160/)
