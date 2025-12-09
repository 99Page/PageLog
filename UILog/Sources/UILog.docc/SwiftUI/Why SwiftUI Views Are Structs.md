# Why SwiftUI Views Are Structs

SwiftUI의 뷰가 구조체로 구현된 이유를 알아봅니다.

## Overview

```swift
class SimpleView: UIView {
    init() {
        super.init(frame: .zero) 
        alpha = 0 
        isEnabled = false
    }
}
```

UIKit의 뷰는 상속으로 구현됩니다. 뷰 구현에 필요한 요소들이 UIView의 프로퍼티와 함수에 모두 구현되어 있습니다. 투명도를 변경하고 싶으면 `.alpha`에 접근해야하고, 활성화 여부를 변경하고 싶으면 `.isEnabled`에 접근해야합니다. 

```swift
struct SimpleView: View {
    var body: some View {
        Text("")
            .opacity(0.5)
            .disabled(true)
    }
}
```

SwiftUI의 `View` 프로토콜은 body를 반환하면 됩니다. 뷰를 커스텀할 때는 여러 modifier들이 사용되고, 각 modifier들 또한 `View`를 반환합니다. 

그리고 각 modifier가 필요한 속성 값을 갖고 있습니다. 위 코드에서는 `opacity()` modifier를 사용해서 투명도를 조절하고 있는데 투명도는 `Text` 혹은 `SimpleView`가 갖는 속성이 아닙니다. 

각 modifier가 필요한 속성을 갖고 있고, 이것이 중첩되어서 뷰를 구성합니다. Text는 기존에는 opacity라는 속성이 없었고, `opacity()`를 사용 한 후에 해당 속성을 갖게 됩니다. 

필요한 modifier를 갖기 전, 뷰는 그 속성을 저장하지 않기때문에 SwiftUI는 가볍습니다.(lightWeighted)

## 참조 

[SwiftUI Essentials](https://developer.apple.com/kr/videos/play/wwdc2019/216/?time=1303)
