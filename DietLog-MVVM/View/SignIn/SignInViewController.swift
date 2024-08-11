//
//  SignInViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import SnapKit
import RxSwift

class SignInViewController: BaseViewController {
    
    // MARK: - UI Component
    private lazy var dietLogLabel = CustomLabel(text: SignInText.dietLog, font: .largeTitle)
    private lazy var signInView = SignInView()

    // MARK: - 변수
    private let viewModel = SignInViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([dietLogLabel, signInView])
        
        setupDietLogLabelUI()
        signInView.configure()
    }
    
    private func setupDietLogLabelUI() {
        dietLogLabel.textAlignment = .center
        dietLogLabel.textColor = .customGreen
    }

    // MARK: - Setup Layout
    override func setupLayout() {
        
        dietLogLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(topView)
        }
        
        signInView.snp.makeConstraints { make in
            make.top.equalTo(dietLogLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.height.equalTo(view.snp.height).dividedBy(3)
        }
    }

    // MARK: - Setup Bind
    override func setupBinding() {        
        signInView.doneButton.rx.tap
            .subscribe() { [weak self] nickname in
                let nicknameTextField = self?.signInView.nicknameTextField.text
                self?.viewModel.emptyCheckTextField(nicknameTextField)
                self?.viewModel.delegate = self
            }
            .disposed(by: disposeBag)
        
        viewModel.signInResult
            .subscribe() { [weak self] result in
                if result {
                    self?.moveToMyInfoView()
                } else {
                    self?.showAlertWithOKButton(title: nil, message: SignInText.emptyCheckError)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 메서드
extension SignInViewController: SignInViewModelDelegate {
    func moveToMyInfoView() {
        showAlertWithOKButton(title: nil, message: SignInText.signInSecces) {
            if let nickname = self.signInView.nicknameTextField.text {
                UserInfoManager.shared.createUserInfo(nickname: nickname)
            }
            let viewController = TabBarViewController()
            self.view.window?.rootViewController = viewController
        }
    }
}
