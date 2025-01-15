//
//  InputFieldView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 1/14/25.
//  Copyright © 2025 Page. All rights reserved.
//

import UIKit
import Combine

struct TextInput {
    var text: String
}

protocol InputFieldDelegate: AnyObject {
    func didAddTextTapped(_ text: String)
}

class InputFieldViewModel {
    @Published var textInput = TextInput(text: "")
    
    let addTextSubject = PassthroughSubject<String, Never>()
    
    func didAddTextTapped() {
        guard !textInput.text.isEmpty else { return }
        
        addTextSubject.send(textInput.text)
        textInput.text = ""
    }
}

class InputFieldView: UIView {
    private let inputTextField = UITextField()
    private let addButton = UIButton(type: .custom)
    
    private var viewModel: InputFieldViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    override var intrinsicContentSize: CGSize {
         CGSize(width: UIView.noIntrinsicMetric, height: 100) // 내부에서 높이 설정
     }
    
    init(viewModel: InputFieldViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(inputTextField)
        addSubview(addButton)
        
        setUpAddButton()
        setUpInputTextFieldView()
        bindViewModel()
    }
    
    private func setUpConstraints() {
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(addButton.snp.leading)
            
            make.bottom.equalTo(addButton.snp.bottom)
            make.top.equalTo(addButton.snp.top)
        }
    }
    
    private func bindViewModel() {
        viewModel.$textInput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.inputTextField.text = text.text
            }
            .store(in: &cancellables)
    }
    
    private func setUpInputTextFieldView() {
        inputTextField.placeholder = "Enter Text"
        inputTextField.borderStyle = .roundedRect
        inputTextField.font = UIFont.systemFont(ofSize: 16)
        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setUpAddButton() {
        addButton.setTitle("Add Text", for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.setTitleColor(.black, for: .normal)
    }
    
    @objc private func textFieldDidChange() {
        viewModel.textInput.text = inputTextField.text ?? ""
    }
    
    
    @objc private func didTapAddButton() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        viewModel.didAddTextTapped()
    }
}
