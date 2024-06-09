//
//  MyInfoViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import FSCalendar
import RxSwift

enum MyInfoViewText: String {
    case welcom = "안녕하세요"
    case myInfo = "내 정보"
    case weight = "체중 (kg)"
    case muscle = "골격근량 (kg)"
    case fat = "체지방량 (%)"
}

class MyInfoViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var modifyNicknameButton = UIButton()
    private lazy var welcomLabel = UILabel()
    private lazy var calendarView = FSCalendar()
    private lazy var calendarBackgroundView = UIView()
    private lazy var myInfoLabel = UILabel()
    private lazy var myInfoStackView = UIStackView()
    private lazy var weightLabel = UILabel()
    private lazy var muscleLabel = UILabel()
    private lazy var fatLabel = UILabel()
    private lazy var floatingButton = UIButton()
    
    // MARK: - 변수
    private let viewModel = MyInfoViewModel()
    private let disposeBag = DisposeBag()
    private var myInfo: MyInfo?
    private var selectedDate: Date = Date.now
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(true)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([modifyNicknameButton,
                          welcomLabel,
                          calendarBackgroundView,
                          myInfoLabel,
                          myInfoStackView,
                          floatingButton])
        
        calendarBackgroundView.addSubview(calendarView)
        
        setupModifyNicknameButtonUI()
        setupWelcomLabelUI()
        setupCalendarViewUI()
        setupStackViewUI()
        setFloatingButtonUI()
    }
    
    private func setupModifyNicknameButtonUI() {
        modifyNicknameButton.setImage(UIImage(systemName: "pencil.tip.crop.circle"), for: .normal)
        modifyNicknameButton.tintColor = .systemGray
    }
    
    private func setupWelcomLabelUI() {        
        welcomLabel.configure(text: "setupWelcomLabelUI", font: .largeTitle)
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
        
        let weightCardView = insertCardViewIntoStackView(title: MyInfoViewText.weight.rawValue,
                                                      label: weightLabel)
        let muscleCardView = insertCardViewIntoStackView(title: MyInfoViewText.muscle.rawValue,
                                                      label: muscleLabel)
        let fatCardView = insertCardViewIntoStackView(title: MyInfoViewText.fat.rawValue,
                                                   label: fatLabel)
        
        myInfoStackView.addArrangedSubview(weightCardView)
        myInfoStackView.addArrangedSubview(muscleCardView)
        myInfoStackView.addArrangedSubview(fatCardView)
    }
    
    private func setFloatingButtonUI() {
        floatingButton.configureFloatingButton(with: "저장",
                                               and: CGFloat(ComponentSize.floatingButton))
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        modifyNicknameButton.snp.makeConstraints { make in
            make.centerY.equalTo(welcomLabel)
            make.trailing.equalToSuperview().offset(-Padding.leftRightSpacing.rawValue)
            make.width.height.equalTo(welcomLabel.font.lineHeight)
        }
        
        welcomLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            make.leading.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.trailing.equalTo(modifyNicknameButton.snp.leading).offset(-4)
        }
        
        calendarBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(welcomLabel.snp.bottom).offset(24)
            make.leading.equalTo(welcomLabel)
            make.trailing.equalTo(modifyNicknameButton)
            
            let height = view.frame.height / 2.8
            make.height.equalTo(height)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        myInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarBackgroundView.snp.bottom).offset(36)
            make.leading.equalTo(welcomLabel)
            make.trailing.equalTo(modifyNicknameButton)
        }
        
        myInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(myInfoLabel.snp.bottom).offset(12)
            make.leading.equalTo(welcomLabel)
            make.trailing.equalTo(modifyNicknameButton)
            let size = view.frame.size.width - (16 * 4) - (24 * 2)
            make.height.equalTo(size / 3)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalTo(calendarBackgroundView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.width.height.equalTo(ComponentSize.floatingButton)
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    // MARK: - Setup Event
    override func setupEvent() {
        modifyNicknameButton.addTarget(self, action: #selector(showModifyNicknameTextField), for: .touchUpInside)
        floatingButton.addTarget(self, action: #selector(moveToSaveMyInfoView), for: .touchUpInside)
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        viewModel.nickname
            .map {"\(MyInfoViewText.welcom.rawValue) \($0 ?? "닉네임")" }
            .bind(to: welcomLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.findMyInfo(by: Date.now)
        
        viewModel.myInfo
            .subscribe { result in
                self.myInfo = result
            }
            .disposed(by: disposeBag)
        
        viewModel.myInfo
            .map { $0?.weight ?? "0" }
            .observe(on: MainScheduler.instance)
            .bind(to: weightLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.myInfo
            .map { $0?.muscle ?? "0" }
            .observe(on: MainScheduler.instance)
            .bind(to: muscleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.myInfo
            .map { $0?.fat ?? "0" }
            .observe(on: MainScheduler.instance)
            .bind(to: fatLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.myInfo
            .map { myInfo in
                myInfo == nil ? "추가" : "수정"
            }
            .bind(to: floatingButton.rx.title(for: . normal))
            .disposed(by: disposeBag)
    }
}

// MARK: - 메서드
extension MyInfoViewController {
    private func insertCardViewIntoStackView(title: String, label: UILabel) -> UIView {
        let cardView = UIView()
        cardView.applyRadius()
        cardView.applyShadow()
        cardView.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        let titleLabel = UILabel()
        titleLabel.configure(text: title, font: .smallBody)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemGray
        stackView.addArrangedSubview(titleLabel)
        
        label.font = .title
        label.textColor = .customYellow
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
        stackView.addArrangedSubview(label)
        
        cardView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 16, right: 8))
        }
        
        return cardView
    }
    
    @objc func showModifyNicknameTextField() {
        let alert = UIAlertController(title: nil, message: "닉네임을 입력해 주세요", preferredStyle: .alert)
        alert.addTextField()
        
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            if let textField = alert.textFields?.first, let text = textField.text {
                self?.viewModel.nickname.onNext(text)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    @objc func moveToSaveMyInfoView() {
        let viewController = SaveMyInfoViewController(myInfo: myInfo, selectedDate: selectedDate)
        viewController.onUpdate = {
            self.viewModel.findMyInfo(by: self.selectedDate)
        }
        if let sheet = viewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(viewController, animated: true)
    }
}

// MARK: - FSCalendar
extension MyInfoViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.findMyInfo(by: date)
        selectedDate = date
    }
}

