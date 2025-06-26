# README

GRDB에 대해서 찾아본 내용과 고찰을 정리한 문서. 

## Overview

GRDB가 point-free에서 만든 라이브러리는 아니지만, SharingGRDB로 래핑하기도 했고 이곳에서 많이 사용될 레퍼런스는 point-free의 영상이기 때문에 이곳에 기록했습니다. 

## Reflections on SharingGRDB 

SharingGRDB는 SwiftData에서 영감을 받은 프레임워크입니다. 로컬 저장소에 쿼리를 하고, 그걸 뷰에 별다른 작업없이 반영해준다는 장점이 있습니다. 하지만 실제로 사용해보면 저장한 값을 그대로 사용하지 않는 경우가 많습니다. DB 조회 후 뷰에 반영하기 위해 타입 매핑을 하는 경우가 많아 SwiftData는 실사용하기는 적합하지 않다고 생각합니다. 이를 모방한 SharingGRDB도 비슷합니다. 상황에 따라 유용하기는 하겠지만 뷰에 그대로 반영하기 위한 타입을 관리하기에는 제약 사항이 많습니다. 


## SQL Builders

하지만 CoreData, SwiftData 대신 SQLite 기반의 GRDB를 사용하는 것 자체는 괜찮은 방안입니다. 따라서 이 쿼리를 편하게 하기 위한 SQL Builder도 편리성을 가져다줄 좋은 프레임워크입니다. 

```swift
struct Select {
  var columns: [String]
  var from: String

  var queryString: String {
    """
    SELECT \(columns.isEmpty ? "*" : columns.joined(separator: ", "))
    FROM \(from)
    """
  }
}

protocol Table {
  associatedtype Columns
  static var tableName: String { get }
  static var columns: Columns { get }
}

extension Table {
  static func select(_ columns: String...) -> Select {
    Select(columns: columns, from: Self.tableName)
  }
  static func select(_ columns: KeyPath<Columns, String>...) -> Select {
    Select(
      columns: columns.map { Self.columns[keyPath: $0] },
      from: tableName
    )
  }
  static func all() -> Select {
    Select(columns: [], from: Self.tableName)
  }
  static func count() -> Select {
    Select(columns: ["count(*)"], from: Self.tableName)
  }
}
```

SQL Builders: Selectes의 핵심 코드입니다. point-free가 래핑하는 과정을 볼 수 있어서 저의 구현 방식과 비교할 수 있었습니다. 이 시리즈에서는 나오지 않았지만 `Columns`를 위해 매크로를 적용할 것 같습니다. 그런데 매크로까지 적용할 필요가 있었는지는 의문입니다.

KeyPath로 접근할 때 `SomType\.property` 이렇게 나오는걸 `property`로 변경해주기 위해 Columns 타입이 필요한데, 굳이 이렇게 하지않고 문자열 파싱으로 충분히 해결할 수 있었을 것 같습니다. 


## References

* [EP#316 SQL Builders: Selects](https://www.pointfree.co/episodes/ep316-sql-builders-selects)
