# View update

SwiftUI에서 뷰를 업데이트하는 방법에 대해서 설명합니다.

## Overvew

![DependencyTree](DependencyTree)

선언한 뷰가 위 이미지처럼 Model data를 의존한다고 가정하겠습니다. 초록색 박스는 뷰의 상하 구조를 나타내고, 파란색 박스는 해당 뷰가 의존 중인 Model data들입니다. 

![DependencyGraph](DependencyGraph)

보기 쉽게 트리 모양을 그래프로 표시하면 이런 구조가 됩니다. <doc:Model-data>에서 값이 변경되면 뷰가 리렌더 된다고 했습니다. 그런데 모든 것을 리렌더하지는 않고, 각 뷰가 의존 중인 Model data의 변경에 대해서만 리렌더 됩니다. 


## Reference

* [Demystify SwiftUI](https://developer.apple.com/kr/videos/play/wwdc2021/10022/)
