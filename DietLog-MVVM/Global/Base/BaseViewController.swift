//
//  BaseViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var topView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customGray
        
        setupTopView()
        
        setupNavigationBar()
        setupUI()
        setupLayout()
        setupDelegate()
        setupEvent()
    }
    
    func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupUI() {}
    
    func setupLayout() {}
    
    func setupDelegate() {}
    
    func setupEvent() {}
}

extension BaseViewController {
    func setupTopView() {
        topView.backgroundColor = .customYellow
        
        view.addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(3)
        }
    }
    
    func displayTopView(_ display: Bool) {
        topView.isHidden = !display
    }
}
