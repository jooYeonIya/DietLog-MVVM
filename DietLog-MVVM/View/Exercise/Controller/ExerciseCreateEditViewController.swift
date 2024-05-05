//
//  ExerciseCreateEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import UIKit
import RxSwift

class ExerciseCreateEditViewController: ExerciseBaseEditViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveData))
        navigationItem.rightBarButtonItem = button
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
}
