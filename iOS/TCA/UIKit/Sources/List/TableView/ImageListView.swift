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

protocol SectionProvidable {
    associatedtype Section: Hashable, Sendable
    var section: Section { get }
}

struct ImageItem: Identifiable, Hashable, SectionProvidable {
    typealias Section = ImageListViewController.Section
    
    
    let id = UUID().uuidString
    let image: ImageResource
    let name: String
    
    var color: ColorResource
    var section: ImageListViewController.Section { .main }
    
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
            case .view(.binding):
                return .none
            case .view(.addButtonTapped):
                let color = ImageItem.colorCandidates.randomElement() ?? .bubblegum
                state.images.append(ImageItem(image: .leaf, name: "leaf", color: color))
                return .none
            case let .view(.deleteButtonTapped(indexPath)):
                state.images.remove(at: indexPath.row)
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
    
    private let tableView: UITableView
    private let addButton = UIButton()
    
    init(store: StoreOf<ImageListFeature>) {
        @UIBindable var binding = store
        self.store = store
        self.tableView = UITableView($binding.images)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
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
        tableView.configureDiffable { tableView, indexPath, id in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell
            
            // id는 AnySendableHashable(또는 타입 소거된 ID)이므로 내부의 base에서 String을 추출
            // 이런 캐스팅은 나쁜 구조인지 의문이 든다.
            // 그런데 TableViewCell도 보면 캐스팅이 강제된다.
            // 저기서도 괜찮으니까 여기서도 괜찮은걸까?
            
            // 해답은 외부 프레임워크에 의한 캐스팅이면 괜찮다.
            // TableViewCell, AnyHashableSendable은 다른 프레임워크에서 정의된 것이고
            // 내부에서 사용하기 위해 캐스팅 중이다.
            // 이런 '경계'에서의 캐스팅은 괜찮다.
            
            // 그런데, 캐스팅을 하는 두 타입이 내가 정의한 타입일때는 문제가된다.
            if let id = id.base as? String {
                // id 정보만 주고, 이를 통해 바인딩 값을 찾기때문에
                // binidng 값은 항상 optional
                // index로 접근하면 런타임 에러 발생
                let binding = self.$store.images[id: id]
                cell?.configure(binding)
                return cell
            } else {
                return cell
            }
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
