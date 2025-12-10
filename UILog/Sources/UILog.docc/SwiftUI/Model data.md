# Model data

@State, @Binding 등의 프로퍼티 래퍼에 대한 내용들입니다. 

## Single source of truth

SwiftUI는 모델 데이터의 변경을 감지해 뷰를 다시 렌더링합니다. 이 과정에서 뷰 인스턴스는 다시 초기화되지만, 내부에 선언된 모델 값들은 그대로 유지됩니다.

이는 SwiftUI가 해당 값들에 대한 의존성(Dependency)을 별도로 추적하기 때문입니다. @State로 선언된 프로퍼티는 독립적인 Persistent Storage에 보관되며, 뷰는 이 저장소를 참조합니다. 비록 뷰가 반복해서 재생성되더라도 SwiftUI가 이 의존성을 관리해 주기 때문에 값이 사라지지 않습니다.

이처럼 별도의 Persistent Storage를 두고 이를 기반으로 의존성을 유지하기 때문에, SwiftUI는 안정적으로 Single Source of Truth 구조를 구현할 수 있습니다.


## Reference

[Data Flow Through SwiftUI](https://developer.apple.com/kr/videos/play/wwdc2019/226/)
