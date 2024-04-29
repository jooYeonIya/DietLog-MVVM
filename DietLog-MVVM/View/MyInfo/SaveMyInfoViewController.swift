//
//  SaveMyInfoViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/29.
//

import UIKit

enum SaveMyInfoViewText: String {
    case viewTitle = "내 정보 입력"
    case selectedDate = "날짜"
}

class SaveMyInfoViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var myInfoTitleLabel = UILabel()
    private lazy var selectedDateTitleLabel = UILabel()
    private lazy var selectedDateLabel = UILabel()
    private lazy var weightTextField = UITextField()
    private lazy var muscleTextField = UITextField()
    private lazy var fatTextField = UITextField()
    private lazy var weightLabel = UILabel()
    private lazy var muscleLabel = UILabel()
    private lazy var fatLabel = UILabel()
    private lazy var doneButton = UIButton()
    
    // MARK: - 변수
    private var myInfo: MyInfo?
    private var selectedDate: Date

    // MARK: - 변수
    override func viewDidLoad() {
        super.viewDidLoad()

        displayTopView(false)
    }
    
    // MARK: - 초기화
    init(myInfo: MyInfo?, selectedDate: Date) {
        self.myInfo = myInfo
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        selectedDateTitleLabel.configure(text: SaveMyInfoViewText.selectedDate.rawValue, font: .title)
        
        let formatter = DateFormatter()
        selectedDateLabel.configure(text: formatter.toString(from: selectedDate), font: .body)
        
        myInfoTitleLabel.configure(text: SaveMyInfoViewText.viewTitle.rawValue, font: .title)
        
        let textField = [weightTextField, muscleTextField, fatTextField]
        let textFieldTitle = [MyInfoViewText.weight.rawValue,
                              MyInfoViewText.muscle.rawValue,
                              MyInfoViewText.fat.rawValue]
        let textFieldLabel = [weightLabel, muscleLabel, fatLabel]
        let textFieldValue = [myInfo?.weight, myInfo?.muscle, myInfo?.fat]
        
        for i in 0..<3 {
            textField[i].configure(width: 36)
            textField[i].keyboardType = .decimalPad
            textField[i].text = textFieldValue[i] ?? "0"
            
            textFieldLabel[i].configure(text: textFieldTitle[i], font: .smallBody)
        }
        
        doneButton.setTitle("저장", for: .normal)
        doneButton.titleLabel?.font = .body
        doneButton.setTitleColor(.black, for: .normal)
        
        view.addSubviews([myInfoTitleLabel,
                          selectedDateTitleLabel,
                          selectedDateLabel,
                          weightTextField,
                          muscleTextField,
                          fatTextField,
                          weightLabel,
                          muscleLabel,
                          fatLabel,
                          doneButton])
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        
        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Padding.leftRightSpacing.rawValue)
            make.centerY.equalTo(selectedDateTitleLabel)
        }
        
        selectedDateTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        selectedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedDateTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(selectedDateTitleLabel)
        }
        
        myInfoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(selectedDateTitleLabel)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(myInfoTitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(selectedDateTitleLabel)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(selectedDateTitleLabel)
            make.height.equalTo(36)
        }
        
        muscleLabel.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(selectedDateTitleLabel)
        }
        
        muscleTextField.snp.makeConstraints { make in
            make.top.equalTo(muscleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(selectedDateTitleLabel)
            make.height.equalTo(36)
        }
        
        fatLabel.snp.makeConstraints { make in
            make.top.equalTo(muscleTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(selectedDateTitleLabel)
        }
        
        fatTextField.snp.makeConstraints { make in
            make.top.equalTo(fatLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(selectedDateTitleLabel)
            make.height.equalTo(36)
        }
    }
}
