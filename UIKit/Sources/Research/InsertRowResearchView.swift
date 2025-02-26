//
//  TopPaginationTableView.swift
//  CaseStudies-UIKit
//
//  Created by Reppley_iOS on 2/26/25.
//  Copyright © 2025 Page. All rights reserved.
//

import SnapKit
import UIKit

/// `tableView.insertRows` 의 동작 방식을 확인하기 위한 뷰입니다.
///
/// top paignation 구현에 필요한 과정입니다.
/// 위로 스크롤 시 페이징을 할 때, 아이템이 앞에 추가된 상태에서 reloadData를 호출하면 스크롤이 튀는 문제가 발생합니다.
/// [이 글](https://velog.io/@s_sub/새싹-iOS-27주차)을 참고하며 insertRows 사용 시 스크롤이 유지된다는 것을 확인 후 실제 동작을 구현해 봤습니다.
/// 실제로 InsertRows를 사용하면 아이템이 앞에 추가됐음에도 스크롤 상태가 유지됩니다. 
class InsertRowResearchView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let printButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Print", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var rowData: [UIColor] = [.blue, .blue, .blue, .blue, .blue, .blue, .blue, .blue, .blue, .blue,]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPrintButton()
        setupTableView()
        makeConstraints()
    }
    
    private func makeConstraints() {
        view.addSubview(printButton)
        view.addSubview(tableView)
        
        printButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(80)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(printButton.snp.top).offset(-10)
        }
    }
    
    private func setupPrintButton() {
        printButton.addTarget(self, action: #selector(printButtonTapped), for: .touchUpInside)
    }
    
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 셀 높이 증가
        tableView.rowHeight = 80
        tableView.separatorStyle = .none // 기본 구분선 제거=
    }
    
    @objc private func printButtonTapped() {
        debugPrint("[before] \(rowData.count)")
        rowData.insert(.red, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        debugPrint("[after] \(rowData.count)")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.configure(color: rowData[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // 셀과 간격 포함한 전체 높이
    }
}

class CustomTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear // 배경 투명
        selectionStyle = .none // 선택 스타일 제거
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(80)
        }
    }
    
    func configure(color: UIColor) {
        containerView.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
