//
//  RootNavigationController.swift
//  UILog
//
//  Created by 노우영 on 10/29/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

class RootNavigationController: UIViewController, NavigationSelectable {

    let tableView = UITableView()
    var sections: [(title: String, items: [NavigationItem])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        addSection(section: "Instrument", title: "Memory", destination: MemoryViewController.self)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        let viewController = item.destination.init()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

protocol NavigationSelectable: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView { get }
    var sections: [(title: String, items: [NavigationItem])] { get set }
}

extension NavigationSelectable {
    func addSection(section: String,
                            title: String,
                            destination: UIViewController.Type) {
        let item = NavigationItem(title: title, destination: destination)
        if let index = sections.firstIndex(where: { $0.title == section }) {
            sections[index].items.append(item)
        } else {
            sections.append((title: section, items: [item]))
        }
    }
}

struct NavigationItem {
    let title: String
    let destination: UIViewController.Type
}
