# Tips


## 배열 할당

```swift

var numbers = [Int]()

// 1. 배열 공간 미리 확보
numbers.reserveCapacity(1000)
for i in 0..<1000 {
    numbers.append(i)
}

// 2. contentsOf 사용 
let items = (0..<1000).map { Int($0) }
numbers.append(contentsOf: items)

```

reserveCapacity(_:)를 사용해 배열에 요소를 반복적으로 추가할 때 성능을 최적화할 수 있습니다. 내부 저장 공간을 미리 확보해 불필요한 메모리 재할당을 방지합니다. 

배열은 메모리 공간에 연속적으로 있어야합니다. 요소를 추가할 때 충분한 공간이 없다면 배열 정보를 복사해 이동시킵니다. 그리고 이건 하나를 추가할 때마다 반복적으로 발생합니다. 

따라서 배열 공간을 미리 확보하거나, 개별 원소가 아니라 전체 배열을 추가하면 복사-이동하는 과정을 줄일 수 있습니다. 


## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
