//
//  SignInViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import SnapKit
import RxSwift
import FirebaseAuth
import FirebaseCore

class SignInViewController: BaseViewController {
    
    // MARK: - UI Component
    private lazy var dietLogLabel = CustomLabel(text: SignInText.dietLog, font: .largeTitle)
    private lazy var signInView = SignInView()
    private lazy var snsLoginView = SnsLoginView()

    // MARK: - 변수
    private let viewModel = SignInViewModel()
    private let disposeBag = DisposeBag()
    
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
            make.top.equalTo(signInView.snp.bottom)
            make.height.equalTo(100)
        }
    }

    // MARK: - Setup Bind
    override func setupBinding() {
        signInView.visibilityToggleButton.rx.tap
            .bind { [weak self] _ in
                self?.toggleVisibilityButton()
            }
            .disposed(by: disposeBag)
        
        signInView.doneButton.rx.tap
            .withLatestFrom(Observable.combineLatest(
                signInView.nicknameTextField.rx.text,
                signInView.emailTextField.rx.text,
                signInView.passwordTextField.rx.text
            ) { nickname, email, password in
                return (
                    nickname?.trimmingCharacters(in: .whitespacesAndNewlines),
                    email?.trimmingCharacters(in: .whitespacesAndNewlines),
                    password?.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            })
            .subscribe() { [weak self] (nickname, email, password) in
                let inputData = SignInInputData(nickname: nickname, email: email, password: password)
                self?.viewModel.emptyCheckTextFields(inputData)
                self?.viewModel.delegate = self
            }
            .disposed(by: disposeBag)
        
        snsLoginView.kakaoButton.rx.tap
            .bind() { [weak self] _ in
                self?.loginWithKakao()
            }
            .disposed(by: disposeBag)
        
        snsLoginView.naverButton.rx.tap
            .bind() { [weak self] _ in
                self?.loginWithNaver()
            }
            .disposed(by: disposeBag)
        
        viewModel.signInResult
            .subscribe() { [weak self] message in
                self?.showAlertWithOKButton(title: nil, message: message)                
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 메서드
extension SignInViewController: SignInViewModelDelegate {
    func moveToMyInfoView() {
        showAlertWithOKButton(title: nil, message: SignInText.signInSecces) {
            let viewController = TabBarViewController()
            self.view.window?.rootViewController = viewController
        }
    }
    
    func toggleVisibilityButton() {
        signInView.passwordTextField.isSecureTextEntry.toggle()
        signInView.visibilityToggleButton.isSelected.toggle()
    }
    
    @objc func loginWithKakao() {
        KakaoService.shared.loginWithKakao()
    }
    
    @objc func loginWithNaver() {
        NaverService.share.loginWithNaver()
    }
}
