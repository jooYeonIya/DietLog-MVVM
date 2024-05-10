//
//  ExerciseModifyEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import UIKit

class ExerciseModifyEditViewController: ExerciseBaseEditViewController {

    // MARK: - 변수
    var exercise: Exercise?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        exerciseEditView.URLTextField.text = exercise?.URL
        exerciseEditView.URLTextField.isEnabled = false
        exerciseEditView.URLTextField.textColor = .systemGray
        
        exerciseEditView.memoTextView.text = exercise?.memo
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        if let id = exercise?.categoryID {
            categoryViewModel.getCategoryData(at: id)
        }
        
        super.setupBinding()
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(updateData))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func updateData() {
        guard let exercise = exercise else { return }
        let result = viewModel.update(exercise)
        let message = result ? LocalizedText.savedData : "예기치 못 한 문제가 발생했습니다. 한 번 더 시도해주세요"
        self.showAlertWithOKButton(title: "", message: message) {
            if result {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
