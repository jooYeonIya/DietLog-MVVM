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
    lazy var stackView = UIStackView()
    lazy var nicknameTextField = UITextField()
    lazy var emailTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var doneButton = UIButton()
    lazy var visibilityToggleButton = UIButton(type: .custom)
    
    // MARK: - setup UI
    func configure() {
        addSubviews([titleLabel, subTitleLabel, stackView, doneButton])
        
        setupBackgroundViewUI()
        setupStackView()
        setupDoneButtonUI()
        
        setupLayout()
    }
    
    private func setupBackgroundViewUI() {
        backgroundColor = .white
        applyShadow()
        applyRadius()
    }
    
    private func setupStackView() {
        let nicknameLabel = CustomLabel(text: SignInText.nickname, font: .smallBody)
        let emailLabel = CustomLabel(text: SignInText.email, font: .smallBody)
        let passwordLabel = CustomLabel(text: SignInText.password, font: .smallBody)
        
        setupTextFieldsUI()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        stackView.addArrangedSubviews([nicknameLabel, nicknameTextField,
                                      emailLabel, emailTextField,
                                      passwordLabel, passwordTextField])
    }
     
    private func setupTextFieldsUI() {
        [nicknameTextField, emailTextField, passwordTextField].forEach {
            $0.configure()
        }
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 4
        buttonConfiguration.baseBackgroundColor = .clear
        buttonConfiguration.baseForegroundColor = .systemGray4
        
        visibilityToggleButton.setImage(.eyeClosed, for: .normal)
        visibilityToggleButton.setImage(.eyeOpen, for: .selected)
        visibilityToggleButton.configuration = buttonConfiguration

        passwordTextField.isSecureTextEntry = true
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
            make.top.equalTo(titleLabel.snp.bottom).offset(4).priority(.required)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(doneButton.snp.top).offset(-12)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        [nicknameTextField, emailTextField, passwordTextField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
            }
        }
      
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Padding.leftRightSpacing.rawValue)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
    }
}
