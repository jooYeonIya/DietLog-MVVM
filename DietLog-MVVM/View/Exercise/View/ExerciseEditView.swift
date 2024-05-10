//
//  ExerciseEditView.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/04.
//

import UIKit

protocol ExerciseEditViewDelegate: AnyObject {
    func moveToSelectCategoryView()
}

class ExerciseEditView: UIView {
    
    // MARK: - Componente
    lazy var stackView = UIStackView()
    
    lazy var URLTextFieldBaseView = UIView()
    lazy var URLTextField = UITextField()
    lazy var URLErrorLabel = UILabel()
    
    lazy var categorySelecteBaseView = UIView()
    lazy var categorySelectedLabel = UILabel()
    
    lazy var memoTextBaseView = UIView()
    lazy var memoTextView = UITextView()
    
    // MARK: - 변수
    weak var delegate: ExerciseEditViewDelegate?
    
    func configure() {
        setupUI()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        addSubview(stackView)
        
        setupStackView()
        setupLayout()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 24
        
        stackView.addArrangedSubview(URLTextFieldBaseView)
        stackView.addArrangedSubview(categorySelecteBaseView)
        stackView.addArrangedSubview(memoTextBaseView)
        
        setupURLTextField()
        setupCategorySelect()
        setupMemoTextView()
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
        URLTextField.becomeFirstResponder()
        
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
    
    private func setupCategorySelect() {
        let label = UILabel()
        label.configure(text: "카테고리 선택" , font: .body)
        
        categorySelectedLabel.font = .smallBody
        categorySelectedLabel.textAlignment = .right
        categorySelectedLabel.numberOfLines = 0
        categorySelectedLabel.lineBreakMode = .byCharWrapping
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.isUserInteractionEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(moveToSelectCategoryView))
        categorySelecteBaseView.addGestureRecognizer(tapGesture)
        categorySelecteBaseView.isUserInteractionEnabled = true
        categorySelecteBaseView.applyRadius()
        categorySelecteBaseView.backgroundColor = .white
        categorySelecteBaseView.addSubviews([label, categorySelectedLabel, button])
        
        label.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        categorySelectedLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.trailing.equalTo(button.snp.leading).offset(-8)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.centerY.equalTo(categorySelectedLabel)
            make.width.greaterThanOrEqualTo(28)
        }
    }
    
    private func setupMemoTextView() {
        let label = UILabel()
        label.configure(text: "메모", font: .body)
        
        memoTextBaseView.applyRadius()
        memoTextBaseView.backgroundColor = .white
        memoTextBaseView.addSubviews([label, memoTextView])
        
        memoTextView.applyRadius()
        memoTextView.layer.borderColor = UIColor.systemGray6.cgColor
        memoTextView.backgroundColor = .systemGray6
        memoTextView.layer.borderWidth = 1.2
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.leading.trailing.equalTo(label)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Padding.leftRightSpacing.rawValue)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Padding.leftRightSpacing.rawValue)
        }
    }
    
    // MARK: - objc 메서드
    @objc func moveToSelectCategoryView() {
        delegate?.moveToSelectCategoryView()
    }
}
