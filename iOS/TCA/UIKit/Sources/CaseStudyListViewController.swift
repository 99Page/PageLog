//  CaseStudyListViewController.swift
//  CaseStudies-TCA-UIKit
//
//  Created by 노우영 on 8/26/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import SnapKit
import ComposableArchitecture

@Reducer
struct CaseStudyFeature {
    @ObservableState
    struct State { }
    
    enum Action { }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

final class CaseStudyListViewController: UIViewController, UITableViewDelegate {
    
    let store: StoreOf<CaseStudyFeature>
    
    init(store: StoreOf<CaseStudyFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Section & Row

    /// 단일 섹션
    enum Section: CaseIterable {
        case list
    }

    /// 테이블 행 모델
    /// - Important: Diffable을 위해 `id`로 고유 식별합니다. 실제 화면 전환은 `key`로 팩토리를 찾아 수행합니다.
    struct Row: Hashable {
        let id = UUID()
        let title: String
        let key: String
    }

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Section, Row>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()

    private var factories: [String: () -> UIViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Case Studies"
        view.backgroundColor = .systemBackground

        setupUI()
        configureDataSource()

        configureItems([
            (title: "ImageList", key: "ImageList", factory: { ImageListViewController(store: Store(initialState: ImageListFeature.State(), reducer: {
                ImageListFeature()
            }))  })
        ])
    }

    // MARK: - Public API

    /// 케이스 스터디 항목과 전환 팩토리를 등록합니다.
    /// - Parameters:
    ///   - items: (타이틀, 키, 팩토리) 튜플 배열
    /// - Important: 동일한 `key`는 마지막 등록이 우선합니다.
    public func configureItems(_ items: [(title: String, key: String, factory: () -> UIViewController)]) {
        items.forEach { item in
            factories[item.key] = item.factory
        }
        
        let rows = items.map { Row(title: $0.title, key: $0.key) }
        applyInitialSnapshot(rows: rows)
    }

    // MARK: - UI 구성

    /// 테이블 뷰 레이아웃 및 델리게이트를 설정합니다.
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 56
        tableView.separatorStyle = .singleLine
    }

    /// Diffable Data Source를 구성합니다.
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Row>(tableView: tableView) { tableView, indexPath, row in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            if #available(iOS 14.0, *) {
                var config = UIListContentConfiguration.valueCell()
                config.text = row.title
                config.secondaryText = nil
                cell.contentConfiguration = config
            } else {
                cell.textLabel?.text = row.title
                cell.detailTextLabel?.text = nil
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    /// 초기 스냅샷을 적용합니다. (전체 갱신)
    /// - Parameter rows: 표시할 행 배열
    private func applyInitialSnapshot(rows: [Row]) {
        snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(rows, toSection: .list)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - UITableViewDelegate

    /// 행 선택 시 해당 키의 팩토리로 뷰컨트롤러를 생성하여 push 합니다.
    /// - Parameters:
    ///   - tableView: 테이블 뷰
    ///   - indexPath: 선택된 인덱스 경로
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let makeVC = factories[row.key] else { return }
        let vc = makeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
