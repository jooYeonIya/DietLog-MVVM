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
        stackVew.axis = .vertical
        stackVew.spacing = 0
        stackVew.alignment = .center
        stackVew.distribution = .equalCentering
        
        let kakaoButton = UIButton()
        kakaoButton.setTitle("카카오로 가입하기", for: .normal)
        
        let naverButton = UIButton()
        naverButton.setTitle("네이버로 가입하기", for: .normal)
        
        [kakaoButton, naverButton].forEach {
            stackVew.addArrangedSubview($0)
            
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .smallBody
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalToSuperview()
            }
        }
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        
        snsTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(stackVew.snp.top).offset(-8)
        }
        
        stackVew.snp.makeConstraints { make in
            make.leading.trailing.equalTo(snsTitleLabel)
        }
    }
}
