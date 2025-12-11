# SwiftUI Performance

SwiftUI의 성능 개선에 대한 내용을 정리합니다. 

## List 

리스트는 ForEach 내부에서 만들어질 행의 크기에 대해서 알고 있어야합니다. 

`행의 개수 = Element 수 * Element 당 뷰의 수`

따라서 뷰의 수는 고정적입니다. 

```swift
struct ListView: View {
    @State var list = List() 
    
    var body: some View {
        List(list.items) { item
            if item.isVisible {
                Row(item)   
            }
        }
    }
}
```

이 상황에서 item.isVisible이 `false` 여도 리스트는 이 뷰를 연산합니다. 행의 수를 알아야하기 때문입니다. 이런 상황에서는 필터링 된 아이템 자체를 리스트에 넘겨줘야합니다. 


```swift
struct ListView: View {
    @State var list = List() 
    
    var body: some View {
        List(list.visibleItems) { item
            Row(item)   
        }
    }
}
```

위 코드로 변경하는 것이 불필요한 뷰를 생성하지 않아 성능이 개선됩니다. 

## Reference

* [Demystify SwiftUI performance](https://developer.apple.com/kr/videos/play/wwdc2023/10160/)
