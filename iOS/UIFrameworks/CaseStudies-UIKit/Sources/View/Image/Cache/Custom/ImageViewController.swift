//
//  ImageViewController.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 5/6/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class ImageViewController: UIViewController {
    let imageCacheView: ImageCacheView
    
    private let imageURL = "https://picsum.photos/200"
    
    private let buttonStackView: UIStackView = {
        let buttonTitles = ["Cache", "Disk", "URL"]
        let buttons = buttonTitles.enumerated().map { index, title -> UIButton in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.addTarget(nil, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return button
        }
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    init() {
        let handler = ImageLoaderFactory.makeHandler()
        self.imageCacheView = ImageCacheView(loadImageHandler: handler)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeConstraints()
        loadImage()
    }
    
    func makeConstraints() {
        view.addSubview(imageCacheView)
        view.addSubview(buttonStackView)
        
        imageCacheView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(300)
            make.centerX.centerY.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(imageCacheView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
    }
    
    func loadImage() {
        imageCacheView.configure()
        imageCacheView.loadImage(fromKey: "https://picsum.photos/200")
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            imageCacheView.loadImageHandler = CacheImageLoader()
            imageCacheView.reloadImage(fromKey: imageURL)
        case 1:
            imageCacheView.loadImageHandler = DiskImageLoader()
            imageCacheView.reloadImage(fromKey: imageURL)
        case 2:
            imageCacheView.loadImageHandler = NetworkImageLoader()
            imageCacheView.reloadImage(fromKey: imageURL)
        default:
            break
        }
    }
}
