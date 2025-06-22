//
//  MainViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 6/22/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit

/// 리스트 항목 모델
struct ListItem {
    let title: String
    let destination: UIViewController.Type
}

/// 메인 화면. 리스트를 보여줌
class MainViewController: UIViewController {

    private let tableView = UITableView()
    private var sections: [(title: String, items: [ListItem])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "리스트"
        setupTableView()
        
        addSection(section: "View", title: "Observation", destination: ObservationViewController.self)
        addSection(section: "View", title: "Image", destination: ImageViewController.self)
        
        addSection(section: "Event", title: "Notification", destination: KeyboardViewController.self)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    /// Helper to add a section with a single item
    private func addSection(section: String,
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
