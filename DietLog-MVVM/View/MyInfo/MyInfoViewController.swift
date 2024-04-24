//
//  MyInfoViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import FSCalendar

enum MyInfoViewText: String {
    case welcom = "안녕하세요"
}

class MyInfoViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var welcomLabel = UILabel()
    
    // MARK: - 변수
    private let nickname: String = "nickname"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(true)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([welcomLabel])
        setupWelcomLabelUI()
    }
    
    private func setupWelcomLabelUI() {
        let text = "\(MyInfoViewText.welcom.rawValue) \(nickname)"
        
        welcomLabel.configure(text: text, font: .largeTitle)
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        welcomLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
    }
}
