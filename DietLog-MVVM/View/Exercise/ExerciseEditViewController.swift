//
//  ExerciseEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import RxSwift
import RxCocoa

enum ExerciseEditOption: Int {
    case URL, category, memo
}

class ExerciseEditViewController: BaseViewController {
    
    // MARK: - Componente
    private lazy var stackView = UIStackView()
    
    private lazy var URLTextFieldBaseView = UIView()
    private lazy var URLTextField = UITextField()
    private lazy var URLErrorLabel = UILabel()
    
    private lazy var categorySelecteBaseView = UIView()
    private lazy var categorySelectedLabel = UILabel()
    
    private lazy var memoTextBaseView = UIView()
    private lazy var memoTextView = UITextView()
    
    // MARK: - 변수
    private var viewModel = ExerciseEditViewModel()
    private var categoryViewModel = SelectCategoryViewModel()
    private var disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubview(stackView)
        
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 24
        
        stackView.addArrangedSubview(URLTextFieldBaseView)
        stackView.addArrangedSubview(categorySelecteBaseView)
        stackView.addArrangedSubview(memoTextBaseView)
        
        setupURLTextField()
        setupCategorySelect()
        setupMemoTextView()
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Padding.leftRightSpacing.rawValue)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Padding.leftRightSpacing.rawValue)
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveData))
        navigationItem.rightBarButtonItem = button
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func saveData() {
        let result = viewModel.saveData()
        let message = result ? "저장했습니다" : "URL 입력 및 카테고리를 선택해 주세요"
        self.showAlertWithOKButton(title: "", message: message) {
            if result {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        URLTextField.rx.text.orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .bind(to: viewModel.URLTextField)
            .disposed(by: disposeBag)
        
        viewModel.URLErrorLabel
            .bind(to: URLErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        categoryViewModel.selectedCategory
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] category in
                self?.categorySelectedLabel.text = category?.title ?? "미선택"
            }
            .disposed(by: disposeBag)
        
        categoryViewModel.selectedCategory
            .map { $0?.id }
            .bind(to: viewModel.selectedCategoryId)
            .disposed(by: disposeBag)
        
        memoTextView.rx.text
            .bind(to: viewModel.memoTextView)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup 메서드
extension ExerciseEditViewController {
    private func setupURLTextField() {
        let label = UILabel()
        label.configure(text: "URL" , font: .body)
        
        URLErrorLabel.configure(text: "", font: .smallBody)
        URLErrorLabel.textColor = .systemRed
        URLErrorLabel.textAlignment = .right
        
        URLTextFieldBaseView.applyRadius()
        URLTextFieldBaseView.backgroundColor = .white
        URLTextFieldBaseView.addSubviews([label, URLTextField, URLErrorLabel])
        
        URLTextField.configure()
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        URLTextField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.leading.trailing.equalTo(label)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
        
        URLErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(URLTextField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(label)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setupCategorySelect() {
        let label = UILabel()
        label.configure(text: "카테고리 선택" , font: .body)
        
        categorySelectedLabel.configure(text: "미선택" , font: .smallBody)
        categorySelectedLabel.textAlignment = .right
        categorySelectedLabel.numberOfLines = 0
        categorySelectedLabel.lineBreakMode = .byCharWrapping
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(moveToSelectCategoryView), for: .touchUpInside)
        
        categorySelecteBaseView.applyRadius()
        categorySelecteBaseView.backgroundColor = .white
        categorySelecteBaseView.addSubviews([label, categorySelectedLabel, button])
        
        label.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        categorySelectedLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.trailing.equalTo(button.snp.leading).offset(-8)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.centerY.equalTo(categorySelectedLabel)
            make.width.greaterThanOrEqualTo(28)
        }
    }
    
    @objc func moveToSelectCategoryView() {
        let viewController = ExerciseSelectCategoryViewController(viewModel: categoryViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupMemoTextView() {
        let label = UILabel()
        label.configure(text: "메모", font: .body)
        
        memoTextBaseView.applyRadius()
        memoTextBaseView.backgroundColor = .white
        memoTextBaseView.addSubviews([label, memoTextView])
        
        memoTextView.applyRadius()
        memoTextView.layer.borderColor = UIColor.systemGray6.cgColor
        memoTextView.backgroundColor = .systemGray6
        memoTextView.layer.borderWidth = 1.2
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.leading.trailing.equalTo(label)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
