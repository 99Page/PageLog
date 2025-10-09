//
//  NavigationSelectable.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit


protocol NavigationSelectable: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView { get }
    var sections: [(title: String, items: [ListItem])] { get set }
}

extension NavigationSelectable {
    func addSection(section: String,
                            title: String,
                            destination: UIViewController.Type) {
        let item = ListItem(title: title, destination: destination)
        if let index = sections.firstIndex(where: { $0.title == section }) {
            sections[index].items.append(item)
        } else {
            sections.append((title: section, items: [item]))
        }
    }
}

struct ListItem {
    let title: String
    let destination: UIViewController.Type
}
