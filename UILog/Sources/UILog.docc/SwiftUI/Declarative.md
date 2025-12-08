# Declarative

SwiftUI의 선언형의 특성에 대해서 알아봅니다. 

## Imperative와 비교

UIKit으로 뷰를 구현했을 때, 여러 이벤트를 받으면서 프로그레스 뷰를 업데이트 하는 상황을 가정하겠습니다. 

```swift
class MainViewController: UIViewController {
    func zoomIn() {
        // 프로그레스 동작 
    }

    func zoomOut() {
        // 프로그레스 종료
    }

    func receiveNotification() {
        // 프로그레스 동작
    }
}
```

멀티 쓰레딩 환경에서, 어떤 시점에서 프로그레스가 계속 동작하게 되어서 이벤트를 추적하기가 어려울 수 있습니다. 그러니 변수 값을 하나 두고, 여기서 관리하도록 합니다. 


```swift
class MainViewController: UIViewController {

    var isProgressViewPresented = false

    func zoomIn() {
        isProgressViewPresented = true 
        updateView()
    }

    func zoomOut() {
        isProgressViewPresented = true
        updateView() 
    }

    func receiveNotification() {
        isProgressViewPresented = true
        updateView()
    }

    func updateView() {
        progressView.isRunning = isProgressViewPresented
    }
}
```

이런 식으로 변수값과 업데이트하려는 뷰의 내용을 매칭시키면 현재 어떤 값인지 그리고 어디서 변경이 됐는지 파악하기 수월합니다. 

이걸 살펴보면 반복되는 부분이 있습니다. 변수 값을 바꾸고, 그 값을 읽어서 뷰를 업데이트하는 부분입니다. 

```swift
struct ProgressView: View {
    @State private var isProgressViewPresented = false

    var body: some View {
        if isProgressViewPresented {
            ProgressView()
        } 
    }
}
```

SwiftUI는 이런 반복적인 부분을 제거해줍니다. 뷰가 필요한 내용을 직접 함수나, 뷰의 상태에 접근해서 업데이트하는 것을 Imperative(명령형)이라고 합니다. 반면 SwiftUI처럼 뷰가 알아서 변경된 내용을 적용해주는 것을 Declarative(선언형)이라고 합니다. 
