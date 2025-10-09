//
//  VanilaImageViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit

/// 많은 이미지를 디코딩하는 환경 예제의 뷰컨트롤러
/// https://developer.apple.com/documentation/uikit/uiimage/preparingfordisplay()
/// preparingForDisplay 메소드를 사용해 메인 쓰레드의 부하를 줄일 수 있다.
class VanilaImageViewController: UIViewController {
    
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
    
    deinit {
        debugPrint("deinit")
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
    let thumbnail = UIImageView()
    private let imageQueue = DispatchQueue(label: "customview.image.decode", qos: .userInitiated)
    
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
        imageQueue.async {
            let decodeImage = UIImage(resource: resource).preparingForDisplay()!
            
            DispatchQueue.main.async {
                self.thumbnail.image = decodeImage
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
    }
}
