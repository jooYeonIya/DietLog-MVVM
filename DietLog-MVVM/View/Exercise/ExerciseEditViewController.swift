//
//  ExerciseEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

enum ExerciseEditOption: Int {
    case URL, category, memo
}

class ExerciseEditViewController: BaseViewController {
    
    // MARK: - Componente
    private lazy var stackView = UIStackView()
    
    private lazy var URLTextFieldBaseView = UIView()
    private lazy var URLTextField = UITextField()
    private lazy var URLErrorLabel = UILabel()
    
    private lazy var categorySelecteBaseView = UIView()
    private lazy var categorySelectedLabel = UILabel()
    
    private lazy var memoTextBaseView = UIView()
    private lazy var memoTextView = UITextView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubview(stackView)
        
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 24
        
        stackView.addArrangedSubview(URLTextFieldBaseView)
        stackView.addArrangedSubview(categorySelecteBaseView)
        stackView.addArrangedSubview(memoTextBaseView)
        
        setupURLTextField()
    }
    
    private func setupURLTextField() {
        let label = UILabel()
        label.configure(text: "URL" , font: .body)
        
        URLErrorLabel.configure(text: "", font: .smallBody)
        URLErrorLabel.textColor = .systemRed
        URLErrorLabel.textAlignment = .right
        
        URLTextFieldBaseView.applyRadius()
        URLTextFieldBaseView.backgroundColor = .white
        URLTextFieldBaseView.addSubviews([label, URLTextField, URLErrorLabel])
        
        URLTextField.configure()
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }

        URLTextField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.leading.trailing.equalTo(label)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        URLErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(URLTextField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(label)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
}
