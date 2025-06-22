# README

StoreKit에 대한 내용을 정리한 문서

## Error case

StoreKit Configuration file을 추가 후 `Product.products(_:)`를 호출 시 
지속적으로 빈 값이 오는 상황이 있습니다.

이런 경우 이렇게 해결할 수 있습니다.

* Product > Scheme > Edit scheme > Run > Options
* StoreKit configuration에 추가한 파일 적용하기



## References

* [StoreKit2](https://developer.apple.com/videos/play/wwdc2021/10114/)
