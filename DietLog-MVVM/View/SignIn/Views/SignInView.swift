//
//  SignInView.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 6/9/24.
//

import Foundation
import UIKit
import SnapKit

class SignInView: UIView {
    
    // MARK: - UI Componet
    lazy var titleLabel = CustomLabel(text: SignInText.title, font: .title)
    lazy var subTitleLabel = CustomLabel(text: SignInText.subTitle, font: .body)
    lazy var nicknameTextField = UITextField()
    lazy var emailTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var doneButton = UIButton()
    lazy var visibilityToggleButton = UIButton(type: .custom)
    
    // MARK: - setup UI
    func configure() {
        addSubviews([titleLabel,
                     subTitleLabel,
                     nicknameTextField,
                     emailTextField,
                     passwordTextField,
                     doneButton])
        
        setupBackgroundViewUI()
        setupTextFieldsUI()
        setupDoneButtonUI()
        
        setupLayout()
    }
    
    private func setupBackgroundViewUI() {
        backgroundColor = .white
        applyShadow()
        applyRadius()
    }
    
     
    private func setupTextFieldsUI() {
        nicknameTextField.configure()
        nicknameTextField.placeholder = SignInText.nickname
        
        emailTextField.configure()
        emailTextField.placeholder = SignInText.email
        
        passwordTextField.configure()
        passwordTextField.placeholder = SignInText.password
        passwordTextField.isSecureTextEntry = true
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 4
        buttonConfiguration.baseBackgroundColor = .clear
        buttonConfiguration.baseForegroundColor = .systemGray4
        
        visibilityToggleButton.setImage(.eyeClosed, for: .normal)
        visibilityToggleButton.setImage(.eyeOpen, for: .selected)
        visibilityToggleButton.configuration = buttonConfiguration

        passwordTextField.rightView = visibilityToggleButton
        passwordTextField.rightViewMode = .always
    }
    
    private func setupDoneButtonUI() {
        let width: CGFloat = CGFloat(ComponentSize.textFieldHeight.rawValue)
        doneButton.configureCircleShape(width: width)
        
        let buttonImgae = UIImage(systemName: ImageName.rightArrow,
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: width / 2, weight: .medium))
        doneButton.setImage(buttonImgae, for: .normal)
        doneButton.tintColor = .white
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-20)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
    }
}
