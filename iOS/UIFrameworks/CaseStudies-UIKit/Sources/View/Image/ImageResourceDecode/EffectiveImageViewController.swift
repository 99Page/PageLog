//
//  EffectiveImageViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/9/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

/// 스크롤 성능과 메모리 사용량을 높힌 뷰컨트롤러.
/// 핵심은 `ImageDecodeView`
///
/// # 측정
/// iPhone 16 Pro - 18.2 기준
/// 메모리 사용량 약 1.0GB -> 95.2MB로 감소
class EffectiveImageViewController: UIViewController {
    
    enum Section: CaseIterable { case main }
    
    private let images: [ImageResource] = [
        .audi, .bear, .benz, .bread, .cherryBlossom,
        .coffee, .ferrari, .goat, .iMac, .leaf,
        .lightHouse, .load, .luvhimbi, .man1, .manAndHorse
    ]
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Section, ImageResource>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        makeDataSource()
        applyInitialSnapshot()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.separatorStyle = .none
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseID)
    }
    
    private func makeDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, ImageResource>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
            cell.configure(resource: itemIdentifier)
            return cell
        }
    }
    
    private func applyInitialSnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageResource>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(images, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

private class ImageCell: UITableViewCell {
    /// 썸네일 이미지 뷰
    let thumbnail = ImageDecodeView()
    
    /// 재사용 식별자
    static let reuseID = "VanilaImageCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
        activateConstraints()
    }
    
    private func configureViews() {
        selectionStyle = .none
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
    }
    
    private func activateConstraints() {
        contentView.addSubview(thumbnail)
        
        thumbnail.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.lessThanOrEqualTo(contentView.layoutMarginsGuide.snp.bottom)
        }
    }
    
    func configure(resource: ImageResource) {
        thumbnail.configure(image: resource)
    }
}
