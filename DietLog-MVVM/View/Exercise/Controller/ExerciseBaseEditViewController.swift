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

class ExerciseBaseEditViewController: BaseViewController {

    // MARK: - Component
    lazy var exerciseEditView = ExerciseEditView()
    
    // MARK: - 변수
    var viewModel = ExerciseEditViewModel()
    var categoryViewModel = SelectCategoryViewModel()
    var disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = exerciseEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
        
        exerciseEditView.configure()
        exerciseEditView.delegate = self
    }
    
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        exerciseEditView.URLTextField.rx.text.orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .bind(to: viewModel.URLTextField)
            .disposed(by: disposeBag)
        
        viewModel.URLErrorLabel
            .bind(to: exerciseEditView.URLErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        categoryViewModel.selectedCategory
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] category in
                self?.exerciseEditView.categorySelectedLabel.text = category?.title ?? "미선택"
            }
            .disposed(by: disposeBag)
        
        categoryViewModel.selectedCategory
            .map { $0?.id }
            .bind(to: viewModel.selectedCategoryId)
            .disposed(by: disposeBag)
        
        exerciseEditView.memoTextView.rx.text
            .bind(to: viewModel.memoTextView)
            .disposed(by: disposeBag)
    }
}

// MARK: - ExerciseEditView
extension ExerciseBaseEditViewController: ExerciseEditViewDelegate {
    func moveToSelectCategoryView() {
        let viewController = ExerciseSelectCategoryViewController(viewModel: categoryViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
