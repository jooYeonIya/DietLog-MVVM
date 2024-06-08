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
    
    private lazy var dietLogLabel = UILabel()
    private lazy var signInView = SignInView()
    private lazy var stackVew = UIStackView()
    private lazy var snsTitleLabel = UILabel()

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
        view.addSubviews([dietLogLabel, signInView, snsTitleLabel, stackVew])
        signInView.configure()
        setupLabelslUI()
        setupStackView()
    }
    
    private func setupLabelslUI() {
        dietLogLabel.configure(text: SignInText.dietLog, font: .largeTitle)
        dietLogLabel.textAlignment = .center
        dietLogLabel.textColor = .customGreen
        
        snsTitleLabel.configure(text: SignInText.sns, font: .boldBody)
        snsTitleLabel.textAlignment = .center
    }

    private func setupStackView() {
        stackVew.axis = .vertical
        stackVew.spacing = 0
        stackVew.alignment = .center
        stackVew.distribution = .equalCentering
        
        let kakaoButton = UIButton()
        kakaoButton.setTitle("카카오로 가입하기", for: .normal)
        kakaoButton.addTarget(self, action: #selector(loginWithKakao), for: .touchUpInside)
        
        let naverButton = UIButton()
        naverButton.setTitle("네이버로 가입하기", for: .normal)
        naverButton.addTarget(self, action: #selector(loginWithNaver), for: .touchUpInside)
        
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
    override func setupLayout() {
        
        dietLogLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(topView)
        }
        
        signInView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.height.equalTo(view.snp.height).dividedBy(2)
        }
        
        dietLogLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signInView.snp.top).offset(-48)
        }

        snsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(signInView.snp.bottom).offset(24)
            make.bottom.equalTo(stackVew.snp.top).offset(-8)
            make.leading.trailing.equalTo(24)
        }
        
        stackVew.snp.makeConstraints { make in
            make.leading.trailing.equalTo(snsTitleLabel)
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
