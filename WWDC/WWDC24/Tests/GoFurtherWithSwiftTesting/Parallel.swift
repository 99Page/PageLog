//
//  Parallel.swift
//  WWDC24Tests
//
//  Created by 노우영 on 9/20/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Testing

/// Swift testing의 모든 테스트는 병렬로 실행된다.
/// 또, 매번 테스트 실행 순서가 랜덤한데 이덕분에 숨겨있는 의존성을 찾을 수 있다.
///
/// Parametrized에 .serialized를 적용시키면 한번에 하나의 테스트만 실행할 수 있다.
/// 그런데 일반적으로는 병렬 테스트가 유용하다.
