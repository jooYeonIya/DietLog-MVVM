//
//  CategoryEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import RxSwift

enum CategoryEditViewText: String {
    case title = "카테고리 이름"
    case emptyCategoryName = "카테고리 이름을 입력해 주세요"
}

class CategoryEditViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var titleLable = UILabel()
    private lazy var categoryNameTextField = UITextField()
    
    // MARK: - 변수
    private var viewModel = CategoryViewModel()
    private var disposeBag = DisposeBag()
    private var category: Category?
    
    // MARK: - 초기화
    init(category: Category? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.category = category
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        titleLable.configure(text: CategoryEditViewText.title.rawValue,
                             font: .title)
        
        categoryNameTextField.configure()
        
        if let category = category {
            categoryNameTextField.text = category.title
        }
        
        view.addSubviews([titleLable, categoryNameTextField])
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        categoryNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(12)
            make.leading.trailing.equalTo(titleLable)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
        }
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(title: "저장",
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTappedSaveButton))
        navigationItem.rightBarButtonItem = button
    }
    
    // MARK: - Setup bind
    override func setupBinding() {
        categoryNameTextField.rx.text.orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .bind(to: viewModel.categoryNameTextField)
            .disposed(by: disposeBag)
    }
}

//MARK: - 메서드
extension CategoryEditViewController {
    
    @objc func didTappedSaveButton() {
        var result = false
        
        if let category = category {
            result = viewModel.modifyCategory(category)
        } else {
            result = viewModel.saveCategory()
        }
        
        let message = result ? "저장했습니다" : CategoryEditViewText.emptyCategoryName.rawValue
        
        showAlertWithOKButton(title: "", message: message) {
            if result {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
