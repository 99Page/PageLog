//
//  NavigationSelectable.swift
//  UILog
//
//  Created by 노우영 on 11/3/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

protocol NavigationSelectable: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView { get }
    var sections: [(title: String, items: [NavigationItem])] { get set }
}

/// 네비게이션 리스트의 항목을 나타내는 모델
/// UIKit, SwiftUI 목적지 모두를 지원하기 위해 뷰컨 생성 클로저를 보관합니다.
struct NavigationItem {
    /// 셀에 표시할 제목
    let title: String
    /// 선택 시 push 할 UIViewController 생성자
    let makeViewController: () -> UIViewController
}

extension NavigationSelectable {
    /// UIKit ViewController 타입을 destination으로 받는 오버로드 함수
    /// - Parameters:
    ///   - section: 섹션 제목
    ///   - title: 셀 제목
    ///   - destination: push할 UIViewController 타입
    func addSection<V: UIViewController>(
        section: String,
        title: String,
        destination: V.Type
    ) {
        let item = NavigationItem(
            title: title,
            makeViewController: { destination.init() }
        )
        if let index = sections.firstIndex(where: { $0.title == section }) {
            sections[index].items.append(item)
        } else {
            sections.append((title: section, items: [item]))
        }
    }

    /// SwiftUI View를 destination으로 받는 오버로드 함수
    /// - Parameters:
    ///   - section: 섹션 제목
    ///   - title: 셀 제목
    ///   - builder: 표시할 SwiftUI View를 생성하는 클로저
    func addSection<Content: View>(
        section: String,
        title: String,
        @ViewBuilder builder: @escaping () -> Content
    ) {
        let item = NavigationItem(
            title: title,
            makeViewController: { UIHostingController(rootView: builder()) }
        )
        if let index = sections.firstIndex(where: { $0.title == section }) {
            sections[index].items.append(item)
        } else {
            sections.append((title: section, items: [item]))
        }
    }
}
