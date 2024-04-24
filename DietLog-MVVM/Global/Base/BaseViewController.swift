//
//  BaseViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customGray
        
        setupNavigationBar()
        setupUI()
        setupLayout()
        setupDelegate()
        setupEvent()
    }
    
    func setupNavigationBar() {}
    
    func setupUI() {}
    
    func setupLayout() {}
    
    func setupDelegate() {}
    
    func setupEvent() {}
}
