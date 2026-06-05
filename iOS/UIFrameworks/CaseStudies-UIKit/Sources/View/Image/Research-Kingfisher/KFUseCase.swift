//
//  KFUseCase.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/9/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

class KFUseCaseViewController: UIViewController {
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let url = URL(string: "")
        
        KF.url(url)
            .set(to: imageView)
    }
}
