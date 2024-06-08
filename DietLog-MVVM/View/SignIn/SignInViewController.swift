//
//  SignInViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import SnapKit
import RxSwift

enum SignInText {
    static let dietLog = "DIET LOG"
    static let title = "안녕하세요"
    static let subTitle = "회원 가입을 진행해 주세요~"
    static let nickname = "닉네임"
    static let email = "이메일"
    static let password = "비밀번호"
    static let sns = "간단하게 가입해 보세요"
}

class SignInViewController: BaseViewController {
    
    // MARK: - UI Componet
    private lazy var backgroundView = UIView()
    private lazy var dietLogLabel = UILabel()
    private lazy var titleLabel = UILabel()
    private lazy var subTitleLabel = UILabel()
    private lazy var nicknameTextField = UITextField()
    private lazy var emailTextField = UITextField()
    private lazy var passwordTextField = UITextField()
    private lazy var doneButton = UIButton()
    private lazy var visibilityToggleButton = UIButton(type: .custom)
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
        view.addSubviews([dietLogLabel, backgroundView, snsTitleLabel, stackVew])
        
        backgroundView.addSubviews([titleLabel,
                                    subTitleLabel,
                                    nicknameTextField,
                                    emailTextField,
                                    passwordTextField,
                                    doneButton])
        
        setupBackgroundViewUI()
        setupLabelslUI()
        setupTextFieldsUI()
        setupDoneButtonUI()
        setupStackView()
    }
    
    private func setupBackgroundViewUI() {
        backgroundView.backgroundColor = .white
        backgroundView.applyShadow()
        backgroundView.applyRadius()
    }
    
    private func setupLabelslUI() {
        dietLogLabel.configure(text: SignInText.dietLog, font: .largeTitle)
        dietLogLabel.textAlignment = .center
        dietLogLabel.textColor = .customGreen
        
        titleLabel.configure(text: SignInText.title, font: .title)
        titleLabel.textAlignment = .left
        
        subTitleLabel.configure(text: SignInText.subTitle, font: .body)
        subTitleLabel.textAlignment = .left
        
        snsTitleLabel.configure(text: SignInText.sns, font: .boldBody)
        snsTitleLabel.textAlignment = .center
    }
    
    private func setupTextFieldsUI() {
        nicknameTextField.configure()
        nicknameTextField.placeholder = SignInText.nickname
        
        emailTextField.configure()
        emailTextField.placeholder = SignInText.email
        
        passwordTextField.configure()
        passwordTextField.placeholder = SignInText.password
        passwordTextField.isSecureTextEntry = true
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 4
        buttonConfiguration.baseBackgroundColor = .clear
        buttonConfiguration.baseForegroundColor = .systemGray4
        
        visibilityToggleButton.setImage(UIImage(named: "eye-closed"), for: .normal)
        visibilityToggleButton.setImage(UIImage(named: "eye-shown"), for: .selected)
        visibilityToggleButton.configuration = buttonConfiguration

        passwordTextField.rightView = visibilityToggleButton
        passwordTextField.rightViewMode = .always
    }
    
    private func setupDoneButtonUI() {
        let width: CGFloat = CGFloat(ComponentSize.textFieldHeight.rawValue)
        doneButton.configureCircleShape(width: width)
        
        let buttonImgae = UIImage(systemName: "arrowshape.turn.up.right",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: width / 2, weight: .medium))
        doneButton.setImage(buttonImgae, for: .normal)
        doneButton.tintColor = .white
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
        
        backgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.height.equalTo(view.snp.height).dividedBy(2)
        }
        
        dietLogLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backgroundView.snp.top).offset(-48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-20)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        snsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(24)
            make.bottom.equalTo(stackVew.snp.top).offset(-8)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        stackVew.snp.makeConstraints { make in
            make.leading.trailing.equalTo(snsTitleLabel)
        }
    }
    
    // MARK: - Setup Event
    override func setupEvent() {
        visibilityToggleButton.addTarget(self, action: #selector(toggleVisibilityButton), for: .touchUpInside)
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        doneButton.rx.tap
            .withLatestFrom(nicknameTextField.rx.text)
            .map {
                $0?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .subscribe() { [weak self] nickname in
                self?.viewModel.nickname.onNext(nickname)
            }.disposed(by: disposeBag)
        
        
        viewModel.signInResult
            .subscribe() { [weak self] result in
                var message = ""
                
                if result {
                    message = "환영합니다"
                } else {
                    message = "닉네임을 입력해 주세요"
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
        passwordTextField.isSecureTextEntry.toggle()
        visibilityToggleButton.isSelected.toggle()
    }
    
    @objc func loginWithKakao() {
        KakaoService.shared.loginWithKakao()
    }
    
    @objc func loginWithNaver() {
        NaverService.share.loginWithNaver()
    }
}
