//
//  SnsLoginView.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 6/9/24.
//

import Foundation
import UIKit

class SnsLoginView: UIView {
    
    // MARK: - UI Component
    private lazy var stackVew = UIStackView()
    private lazy var snsTitleLabel = CustomLabel(text: SignInText.sns, font: .boldBody)
    lazy var kakaoButton = UIButton()
    lazy var naverButton = UIButton()
    
    // MARK: - Setup UI
    func configure() {
        addSubviews([snsTitleLabel, stackVew])
        
        setupLabelslUI()
        setupStackView()
        setupLayout()
    }
    
    private func setupLabelslUI() {
        snsTitleLabel.textAlignment = .center
    }
    
    private func setupStackView() {
        stackVew.axis = .horizontal
        stackVew.spacing = 24
        stackVew.alignment = .center
        stackVew.distribution = .equalCentering
        
        kakaoButton.setImage(.kakaoLogo, for: .normal)
        
        naverButton.setImage(.naverLogo, for: .normal)
        
        [kakaoButton, naverButton].forEach { button in
            stackVew.addArrangedSubview(button)
            
            button.snp.makeConstraints { make in
                make.width.height.equalTo(ComponentSize.logoButton)
            }
        }
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        
        snsTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        stackVew.snp.makeConstraints { make in
            make.top.equalTo(snsTitleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(ComponentSize.logoButton)
            
            let width = ComponentSize.logoButton * 2 + 24
            make.width.equalTo(width)
        }
    }
}
