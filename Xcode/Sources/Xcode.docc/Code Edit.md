# Code Edit

Xcode 사용 중, 직접적인 코드 작성이나 코드 작성에 도움이 되는 내용을 정리한 글 


## Playground 

 [Running code snippets using the playground macro](https://developer.apple.com/documentation/Xcode/running-code-snippets-using-the-playground-macro)

Xcode 26부터, 코드의 내용을 즉시 시각적으로 확인할 수 있는 내용을 제공해줍니다. 

```swift
func plus(a: Int, b: Int) -> Int {
    return a + b
}
```

앱 개발 중에는 위 함수의 결과를 즉시 확인하기 어렵습니다. 실제 앱을 실행 후 UI로 확인을 하거나 print로 출력을 해야 확인할 수 있습니다. Playground 매크로를 사용하면 이 함수의 결과를 즉시 확인할 수 있습니다. 

@Row {
    @Column {
        ```swift
        import Playgrounds

        #Playground {
            let value = plus(a: 1, b: 2)
        }

        ```
    }
    
    @Column {
        ![Playground](Playground)
    }
}

좌측 코드를 입력하면 Canvas에서 우측의 결과를 시각적으로 확인 가능합니다. 

