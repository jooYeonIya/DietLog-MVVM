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
    private lazy var dietLogLabel = UILabel()
    private lazy var signInView = SignInView()
    private lazy var snsLoginView = SnsLoginView()

    // MARK: - 변수
    private let viewModel = SignInViewModel()
    private let disposeBag = DisposeBag()
    private var isCompletedNickNameCheck = false {
        willSet {
            if newValue {
                moveToMyInfoView()
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([dietLogLabel, signInView, snsLoginView])
        
        setupDietLogLabelUI()
        signInView.configure()
        snsLoginView.configure()
    }
    
    private func setupDietLogLabelUI() {
        dietLogLabel.configure(text: SignInText.dietLog, font: .largeTitle)
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
            make.height.equalTo(view.snp.height).dividedBy(2)
        }
        
        snsLoginView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(signInView)
            make.top.equalTo(signInView.snp.bottom).offset(24)
        }
    }
    
    // MARK: - Setup Event
    override func setupEvent() {
//        visibilityToggleButton.addTarget(self, action: #selector(toggleVisibilityButton), for: .touchUpInside)
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
//        doneButton.rx.tap
//            .withLatestFrom(nicknameTextField.rx.text)
//            .map {
//                $0?.trimmingCharacters(in: .whitespacesAndNewlines)
//            }
//            .subscribe() { [weak self] nickname in
//                self?.viewModel.nickname.onNext(nickname)
//            }.disposed(by: disposeBag)
        
        
        viewModel.signInResult
            .subscribe() { [weak self] result in
                var message = ""
                
                if result {
                    message = SignInText.welcom
                } else {
                    message = SignInText.nicknameEmptyError
                }
                
                self?.showAlertWithOKButton(title: nil, message: message) {
                    self?.isCompletedNickNameCheck = result
                }
                
            }.disposed(by: disposeBag)
    }
}

// MARK: - 메서드
extension SignInViewController {
    private func moveToMyInfoView() {
        let viewController = TabBarViewController()
        view.window?.rootViewController = viewController
    }
    
    @objc func toggleVisibilityButton() {
//        passwordTextField.isSecureTextEntry.toggle()
//        visibilityToggleButton.isSelected.toggle()
    }
    
    @objc func loginWithKakao() {
        KakaoService.shared.loginWithKakao()
    }
    
    @objc func loginWithNaver() {
        NaverService.share.loginWithNaver()
    }
}
