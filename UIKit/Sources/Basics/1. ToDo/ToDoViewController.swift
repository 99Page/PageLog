//
//  ToDoViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import SnapKit
import Combine

/// UIKit의 기본 사용 방법을 알기위해 만든 To Do 화면 UIViewController.
///
/// ChatGPT의 추천을 기반으로 SnapKit + Combine + MVVM 사용.
///
/// # UIViewController
///
/// 직접적으로 UIVinewController를 사용할 일은 거의 없고, 대부분은 상속을 통해서 사용한다. UIViewController는 다음 기능들을 한다.
///
///  1. 변경된 데이터에 맞도록 뷰 갱신
///  2. 유저 상호작용 응답
///  3. 뷰의 크기 및 배치 변경
///  4. 앱 내의 다른 뷰 컨트롤러나 오브젝트 배치
///
///  ViewController는 뷰 계층 구조에서 발생하는 이벤트를 처리한다. 뷰 컨트롤러가 이벤트를 처리하지 않을 경우 해당 이벤트를 상위 뷰로 보낼 수도 있다.
///
///  ## View 회전 처리
///
///  iOS 8 이상 버전부터는, 화면 방향이 바뀌면 아래 메소드가 호출된다.
///
///  * `viewWillTransition(to:with:)`
///  * `willRotate(to:duration:)`
///  * `willAnimateRotation(to:duration:)`
///  * `didRotate(from:)`
///  * `viewWillLayoutSubviews()`
///
///  앱이 화면 방향을 지원하지 않을 경우, `viewWillLayoutSubviews()` 만 호출한다.
///
///  ## Container View Controller
///
///  View Controller는 다른 여러 child view controller를 갖는 container로서 동작할 수도 있다. 자식 간의 관계, 표시할 자식의 최대 수 등을 제어할 때 유용하다.
///
///  Container View Controller는 다음 메소드를 사용한다.
///
///  * addChild(_:)
///  * removeFromParent()
///  * willMove(toParent:)
///  * didMove(toParent:)
///
/// ## 메모리 관리
///
/// `didReceiveMemoryWarning()` 을 통해 메모리가 부족한 경우의 처리를 할 수 있다. 이 메소드를 불필요한 메모리를 해제해준다.
///
/// # 관련 문서
/// [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller)
///
class ToDoViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let textStackView = UIStackView()
    
    private let inputFieldView: InputFieldView
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var viewModel = ToDoViewModel()
    
    init() {
        self.inputFieldView = InputFieldView(viewModel: viewModel.inputFieldViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.inputFieldView = InputFieldView(viewModel: viewModel.inputFieldViewModel)
        super.init(coder: coder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        /// 네비게이션 바 숨기기
        /// viewWillAppear 단계에서 호출하면 다른 뷰 컨트롤러 설정의 영향이 미치지 않는다.
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /// Sets up the view with a UIScrollView and UILabel to display scrollable text.
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(inputFieldView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(textStackView)
        
        setUpScrollView()
        setUpContentView()
        setUpTextStackView()
    }
    
    private func setUpContentView() {
        contentView.backgroundColor = .red
    }
    
    private func setUpTextStackView() {
        textStackView.axis = .vertical
        textStackView.spacing = 8
        textStackView.alignment = .fill
        textStackView.distribution = .equalSpacing
    }
    
    private func setUpScrollView() {
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(inputFieldView.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // TextStackView 제약
        textStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        inputFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            
            make.height.equalTo(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.$textList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] texts in
                self?.updateStackView(with: texts)
            }
            .store(in: &cancellables)
    }
    
    private func updateStackView(with texts: [String]) {
        textStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        texts.forEach { text in
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            textStackView.addArrangedSubview(label)
        }
    }
}
