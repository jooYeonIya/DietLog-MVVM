//
//  CategoryEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

enum CategoryEditViewText: String {
    case title = "카테고리 이름"
}

class CategoryEditViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var titleLable = UILabel()
    private lazy var categoryNameTextField = UITextField()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        titleLable.configure(text: CategoryEditViewText.title.rawValue,
                             font: .title)
        
        categoryNameTextField.configure()
        
        view.addSubviews([titleLable, categoryNameTextField])
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        categoryNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(12)
            make.leading.trailing.equalTo(titleLable)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
    }
}
