# TIL



## CollectionView 

```swift
class PhotoCollectionViewCell: UICollectionViewCell {
    let view = PhotoCellView(frame: .zero)
    // 생략
}

```

이런식으로 재사용할 수 있는 view를 collection view로 사용하고 있는 상황을 가정하자. 이 view의 bounds를 출력하고 싶다. 


```swift
class PhotoCollectionViewCell: UICollectionViewCell {
    func configure() {
        view.configure() 
        debugPrunt(self.bounds) // OK!
    }
}

class PhotoCellView: UICollectionViewCell {
    func configure() {
        view.configure() 
        debugPrunt(self.bounds) // Fail!
    }
}
```

CollectionViewCell 내부에서는 정상 출력되지만 PhotoCellView에서는 안된다. 


## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
