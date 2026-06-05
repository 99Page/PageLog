# Testing

composable archictecture 사용 중, 테스트와 관련된 문제에 대해서 정리한 문서

## Infer


![infer-fail-image](infer-fail)

TestStore 선언 후 변수에 접근해보면, 타입을 추론하지 못해서 ``<<error type>>`` 이라는 표시가 나온다. 이대로 사용해도 빌드는 정상적으로 되지만 코드 자동완성 기능을 사용하지 못해 직접 Action의 case명을 찾아야해서 불편하다.

![infer-success-image](infer-success)

타입명을 구체적으로 명시해주면 타입에 대한 추론이 가능해지고 코드 자동완성 기능도 사용할 수 있다. 테스트 파일에서 반복적으로 타입을 명시해줘야하기 때문에 **typealias** 를 사용하면 편리하다.
