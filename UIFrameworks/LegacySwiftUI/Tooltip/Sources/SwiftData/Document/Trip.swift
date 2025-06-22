//
//  Trip.swift
//  Tooltip
//
//  Created by wooyoung on 6/12/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import SwiftData

/// model layer가 되는 것들
/// 1. Primitive type
/// 2. Codable protocol을 채택한 value type
///
@Model
class Trip {
    /// Attribute 매크로를 이용해 프로퍼티의 동작을 커스컴할 수 있다.
    /// 아래 unique는 name값이 유일하도록 해준다.
    @Attribute(.unique) 
    var name: String
    
    var destination: String
    var startDate: Date
    var endDate: Date
    
    /// 다른 Model이 프로퍼티에 있으면 기본적인 Relation 관계는 nil이다.
    /// deleteRule을 cascade로 설정함으로써 Trip을 삭제하면 Accomodation도 같이 삭제하도록 변경할 수 있다.
    @Relationship(deleteRule: .cascade)
    var accommodation: Accomodation?
    
    /// 영속성에 저장하지 않으려면
    /// @Transient를 사용한다. 
    @Transient
    var detinationWeather = Weather()
    
    init(name: String, destination: String, startDate: Date, endDate: Date, accommodation: Accomodation? = nil) {
        self.name = name
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.accommodation = accommodation
    }
}

@Model
class Accomodation {
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
}

struct Weather {
    let value: Int = 0
}
