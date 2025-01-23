# ``CaseStudies-TCA``

ComposableArchictecture 중, PersitentData에 대해서 정리한 파일

## Overview

Point-free에서 제공해주는 PersistentData 처리 방법은 두가지가 있다.

* SharedReader: SQLite 기반. 복잡한 데이터, 복잡한 쿼리를 처리할 때 사용
* Shared: UserDefault 기반. 간단한 데이터를 처리할 때 사용

## SharedReader

`@Shared` 매크로를 사용해서 데이터를 저장할 수 있지만 정렬을 처리할 때 문제가 생긴다. 
정렬 후 화면에 re-render하고 싶다면 디스크에 저장된 값도 정렬된 순서에 맞게 다시 저장해야한다.
`@Shared` 로는 이런 복잡한 처리를 할 때 리소스가 크다는 단점이 있다.

`GRDB` 같은 라이브러리를 사용한다면 어느 정도 처리가 가능하지만 
많은 DB 처리 후 Model data에 반영해줘야해서 많은 bolier-plate 코드가 생긴다.

`@SharedReader`는 위의 문제점들을 해결하기 위해 사용한다. 

## Reference

 [Ep#309 Sharing with SQLite: The Problems](https://www.pointfree.co/episodes/ep309-sharing-with-sqlite-the-problems#downloads)


 [Ep#310 Sharing with SQLite: The Solution](https://www.pointfree.co/episodes/ep310-sharing-with-sqlite-the-solution)
