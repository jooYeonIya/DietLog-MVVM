//
//  SignInViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import SnapKit
import RxSwift

enum SignInText: String {
    case dietLog = "DIET LOG"
    case title = "안녕하세요"
    case subTitle = "앞으로 사용할 닉네임을 등록해 주세요"
}

class SignInViewController: BaseViewController {
    
    // MARK: - UI Componet
    private lazy var backgroundView = UIView()
    private lazy var dietLogLabel = UILabel()
    private lazy var titleLabel = UILabel()
    private lazy var subTitleLabel = UILabel()
    private lazy var nicknameTextField = UITextField()
    private lazy var doneButton = UIButton()

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
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([backgroundView,
                          dietLogLabel])
        
        backgroundView.addSubviews([titleLabel,
                                    subTitleLabel,
                                    nicknameTextField,
                                    doneButton])
        
        setupBackgroundViewUI()
        setupLabelslUI()
        setupNicknameTextFieldUI()
        setupDoneButtonUI()
        
    }
    
    private func setupBackgroundViewUI() {
        backgroundView.backgroundColor = .white
        backgroundView.applyShadow()
        backgroundView.applyRadius()
    }
    
    private func setupLabelslUI() {
        dietLogLabel.configure(text: SignInText.dietLog.rawValue, font: .largeTitle)
        dietLogLabel.textAlignment = .center
        dietLogLabel.textColor = .customGreen
        
        titleLabel.configure(text: SignInText.title.rawValue, font: .title)
        titleLabel.textAlignment = .left
        
        subTitleLabel.configure(text: SignInText.subTitle.rawValue, font: .body)
        subTitleLabel.textAlignment = .left
    }
    
    private func setupNicknameTextFieldUI() {
        nicknameTextField.configure()
        nicknameTextField.becomeFirstResponder()
    }
    
    private func setupDoneButtonUI() {
        let width: CGFloat = CGFloat(ComponentSize.textFieldHeight.rawValue)
        doneButton.configureCircleShape(width: width)
        
        let buttonImgae = UIImage(systemName: "arrowshape.turn.up.right",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: width / 2, weight: .medium))
        doneButton.setImage(buttonImgae, for: .normal)
        doneButton.tintColor = .white
        
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        backgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.height.equalTo(view.snp.height).dividedBy(4)
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
            make.top.greaterThanOrEqualTo(subTitleLabel.snp.bottom).offset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(-48)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameTextField)
            make.leading.lessThanOrEqualTo(nicknameTextField.snp.trailing).offset(4)
            make.trailing.equalTo(titleLabel)
            make.width.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
    }
}

// MARK: - 메서드
extension SignInViewController {
    private func moveToMyInfoView() {
        let viewController = TabBarViewController()
        view.window?.rootViewController = viewController
    }
}
