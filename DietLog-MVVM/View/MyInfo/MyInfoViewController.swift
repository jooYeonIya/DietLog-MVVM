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
    case myInfo = "내 정보"
    case weight = "체중 (kg)"
    case muscle = "골격근량 (kg)"
    case fat = "체지방량 (%)"
}

class MyInfoViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var welcomLabel = UILabel()
    private lazy var calendarView = FSCalendar()
    private lazy var calendarBackgroundView = UIView()
    private lazy var myInfoLabel = UILabel()
    private lazy var myInfoStackView = UIStackView()
    private lazy var weightTextField = UITextField()
    private lazy var muscleTextField = UITextField()
    private lazy var fatTextField = UITextField()
    private lazy var floatingButton = UIButton()
    
    // MARK: - 변수
    private let nickname: String = "nickname"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(true)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([welcomLabel,
                          calendarBackgroundView,
                          myInfoLabel,
                          myInfoStackView,
                          floatingButton])
        
        calendarBackgroundView.addSubview(calendarView)
        
        setupWelcomLabelUI()
        setupCalendarViewUI()
        setupStackViewUI()
        setFloatingButtonUI()
    }
    
    private func setupWelcomLabelUI() {
        let text = "\(MyInfoViewText.welcom.rawValue) \(nickname)"
        
        welcomLabel.configure(text: text, font: .largeTitle)
    }
    
    private func setupCalendarViewUI() {
        calendarView.configure()
        
        calendarBackgroundView.backgroundColor = .white
        calendarBackgroundView.applyShadow()
        calendarBackgroundView.applyRadius()
    }
    
    private func setupStackViewUI() {
        myInfoLabel.configure(text: MyInfoViewText.myInfo.rawValue, font: .title)
        
        myInfoStackView.axis = .horizontal
        myInfoStackView.spacing = 16
        myInfoStackView.distribution = .fillEqually
        
        let weightCardView = creatCardViewInStackView(text: MyInfoViewText.weight.rawValue,
                                                  isEditable: true)
        let muscleCardView = creatCardViewInStackView(text: MyInfoViewText.muscle.rawValue,
                                                  isEditable: true)
        let fatCardView = creatCardViewInStackView(text: MyInfoViewText.fat.rawValue,
                                               isEditable: true)
        
        myInfoStackView.addArrangedSubview(weightCardView)
        myInfoStackView.addArrangedSubview(muscleCardView)
        myInfoStackView.addArrangedSubview(fatCardView)
    }
    
    private func setFloatingButtonUI() {
        floatingButton.configureFloatingButton(with: "저장",
                                               and: CGFloat(ComponentSize.floatingButton.rawValue))
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        welcomLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        calendarBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(welcomLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(welcomLabel)
            make.height.equalTo(360)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        myInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarBackgroundView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(welcomLabel).inset(16)
        }
        
        myInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(myInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(myInfoLabel)
            let size = view.frame.size.width - (16 * 4) - (24 * 2)
            make.height.equalTo(size / 3)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalTo(welcomLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.width.height.equalTo(ComponentSize.floatingButton.rawValue)
        }
    }
}

// MARK: - 메서드
extension MyInfoViewController {
    private func creatCardViewInStackView(text: String, isEditable: Bool) -> UIView {
        let cardView = UIView()
        cardView.applyRadius()
        cardView.applyShadow()
        cardView.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        let label = UILabel()
        label.configure(text: text, font: .smallBody)
        label.textAlignment = .center
        label.textColor = .systemGray
        stackView.addArrangedSubview(label)
        
        if isEditable {
            let textField = UITextField()
            textField.configure()
            textField.layer.cornerRadius = 14
            textField.keyboardType = .decimalPad
            stackView.addArrangedSubview(textField)
            textField.snp.makeConstraints { make in
                make.height.equalTo(28)
            }
        } else {
            let label = UILabel()
            label.configure(text: "123", font: .title)
            stackView.addArrangedSubview(label)
        }
        
        cardView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8))
        }
        
        return cardView
    }
}
