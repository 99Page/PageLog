# Environment In SwiftUI

SwiftUI의 Environment에 대해서 알아봅니다.

## Overview 

Environment는 뷰 계층에 전파되는 의존 관계와 상태 값을 뜻합니다.  


```swift
struct ParentView: View {
    var body: some View {
        ChildView() 
    }
}

struct ChildView: View {
    var body: some View {
        Rectangle() 
    }
}
```

위 코드에서 ParentView와 ChildView는 계층 구조입니다. 여기서 `disabled()`를 적용하면 이것을 처리하는 Environtment 값에 영향을 줍니다. 

```swift
struct ParentView: View {
    var body: some View {
        ChildView() 
            .disabled(true)
    }
}

struct ChildView: View {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var body: some View {
        Rectangle() 
    }
}
```

ParentView에서 ChildView에 disabled()를 적용하면, 여기에 연관된 Environment 값이 isEnabled가 false로 변경됩니다. 그리고 이것은 하위 계층에 모두 전파되어, ChildView의 하위 계층 뷰가 있다면 그곳에서도 똑같은 영향을 주게 됩니다. 


## Reference

[SwiftUI Essentials](https://developer.apple.com/kr/videos/play/wwdc2019/216/?time=2193)
