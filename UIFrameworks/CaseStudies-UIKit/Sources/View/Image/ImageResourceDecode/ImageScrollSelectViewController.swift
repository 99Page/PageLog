//
//  ImageScrollSelectViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

final class ImageScrollSelectViewController: UIViewController, NavigationSelectable {
    let tableView = UITableView()
    var sections: [(title: String, items: [ListItem])] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        addSection(section: "Section", title: "VanilaImageView", destination: VanilaImageViewController.self)
        addSection(section: "Section", title: "EffectiveDecode", destination: EffectiveImageViewController.self)
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
