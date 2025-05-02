//
//  ExpandableCollectionViewCOntroller.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 4/24/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import SnapKit

/// 섹션 정의 (단일 섹션 사용)
enum Section {
    case main
}

/// 식별 가능한 이미지 아이템

struct Item: Hashable {
    let id = UUID()
    let image: ImageResource
    
    static func mocks() -> [Self] {
        var result = [Self]()
        (0..<5).forEach { _ in
            result.append(contentsOf: items().map { Item(image: $0) })
        }
        return result
    }
    
    /// 21개의 이미지 리소스를 반환
    static func items() -> [ImageResource] {
        [
            .man1,
            .manAndHorse,
            .woman1,
            .woman2,
            .woman3,
            .leaf,
            .luvhimbi,
            .tokyoTower,
            .signpost,
            .tulip,
            .bread,
            .bear,
            .pierogi,
            .pastelCity,
            .coffee,
            .load,
            .sunflower,
            .cherryBlossom,
            .man1,
            .manAndHorse,
            .woman1
        ]
    }
}

/// 이미지만 표시하는 컬렉션 뷰 컨트롤러
final class ExpandableCollectionViewController: UIViewController {

    var items: [Item] = Item.mocks()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var collectionState = CollectionState()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupDataSource()
        setupGesture()
        applySnapshot()
    }

    /// 핀치 제스처 등록
    private func setupGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        collectionView.addGestureRecognizer(pinchGesture)
    }

    /// 컬렉션 뷰 초기 설정
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// DiffableDataSource 설정
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
            cell.imageView.image = UIImage(resource: item.image)
            return cell
        }
    }

    /// Snapshot을 생성하고 적용
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ExpandableCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionState.cachedWidth == nil {
            collectionState.cachedWidth = collectionView.frame.inset(by: collectionView.contentInset).width
        }
        
        let width = collectionView.frame.inset(by: collectionView.contentInset).width / CGFloat(collectionState.maxColumnCount)
        let height = width
        return CGSize(width: width, height: height)
    }
}

/// 이미지만 보여주는 셀
final class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
