//
//  ImageListView.swift
//  CaseStudies-TCA-UIKit
//
//  Created by 노우영 on 8/26/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import ComposableArchitecture
import UIKit
import SnapKit
import SwiftUI

struct ImageItem: Identifiable, Hashable {
    
    let id = UUID().uuidString
    let image: ImageResource
    let name: String
    
    var color: ColorResource
    
    static var colorCandidates: [ColorResource] {
        [.bubblegum, .buttercup, .indigo, .lavender, .magenta, .orange, .navy, .poppy, .seafoam]
    }
    
    static var bear: ImageItem {
        ImageItem(image: .bear, name: "bear", color: ImageItem.colorCandidates.randomElement() ?? .bubblegum)
    }
}

@Reducer
struct ImageListFeature {
    @ObservableState
    struct State {
        var images = IdentifiedArrayOf<ImageItem>()
        var previousImages = IdentifiedArrayOf<ImageItem>()
        var snapshot: Snapshot = .apply([])
        
        enum Snapshot: Equatable {
            case apply([ImageItem])
            case reload([ImageItem])
            case none
        }
    }
    
    enum Action: ViewAction {
        case view(View)
        
        enum View: BindableAction {
            case binding(BindingAction<State>)
            case addButtonTapped
            case deleteButtonTapped(indexPath: IndexPath)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.binding(\.images)):
                let old = state.previousImages
                let changedItems: [ImageItem] = state.images.compactMap { item in
                    guard let oldItem = old[id: item.id] else { return nil }
                    return oldItem != item ? oldItem : nil
                }
                
                state.snapshot = .reload(changedItems)
                return .none
            case .view(.binding):
                return .none
            case .view(.addButtonTapped):
                let color = ImageItem.colorCandidates.randomElement() ?? .bubblegum
                state.images.append(ImageItem(image: .leaf, name: "leaf", color: color))
                state.snapshot = .apply(state.images.elements)
                return .none
            case let .view(.deleteButtonTapped(indexPath)):
                state.images.remove(at: indexPath.row)
                state.snapshot = .apply(state.images.elements)
                return .none
            }
        }
    }
}

@ViewAction(for: ImageListFeature.self)
final class ImageListViewController: UIViewController, UITableViewDelegate {
    
    @UIBindable var store: StoreOf<ImageListFeature>
    
    enum Section: CaseIterable {
        case main
    }
    
    private let tableView = UITableView()
    
    // 스냅샷에는 아이디값만 사용합니다.
    private var dataSource: UITableViewDiffableDataSource<Section, String>!
    private let addButton = UIButton()
    
    init(store: StoreOf<ImageListFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        updateView()
    }
    
    private func updateView() {
        observe { [weak self] in
            guard let self else { return }
            
            switch store.snapshot {
            case let .apply(items):
                applySnapshot(items: items)
            case let .reload(items):
                applyUpdate(items: items)
            case .none:
                break
            }
            
            // observe 내부에서는 상태가 바뀌어도 observe 내부가 다시 호출되지 않는다.
            store.snapshot = .none
            store.previousImages = store.images
        }
    }
    
    private func applyUpdate(items: [ImageItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(items.map(\.id))
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySnapshot(items: [ImageItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        // 내부 리스트를 전체 초기화하는 방법
        // 초기 로드 + 전체 갱신
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items.map(\.id), toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func setupView() {
        title = "Diffable Table"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        tableView.rowHeight = 100
        setupDataSource()
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.blue, for: .normal)
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    }
    
    
    @objc private func didTapAdd() {
        send(.addButtonTapped)
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView) { tableView, indexPath, id in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell
            
            
            // id 정보만 주고, 이를 통해 바인딩 값을 찾기때문에
            // binidng 값은 항상 optional
            let binding = self.$store.images[id: id]

            cell?.configure(binding)
            return cell
        }
    }
    
    private func makeConstraints() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top).offset(-10)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(50)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            self?.send(.deleteButtonTapped(indexPath: indexPath))
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

#Preview {
    
    let store = Store(initialState: ImageListFeature.State()) {
        ImageListFeature()
    }
    
    ViewControllerPreview {
        ImageListViewController(store: store)
    }
}
