//
//  MealCreateEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/01.
//

import UIKit
import RxSwift

class MealCreateEditViewController: MealEditViewController {
    
    // MARK: - 변수
    private var selectedDate: Date = Date.now
    private var viewModel = MealEditViewModel()
    private var disposeBag = DisposeBag()

    // MARK: - 초기화
    init(selectedDate: Date) {
        super.init(nibName: nil, bundle: nil)
        self.selectedDate = selectedDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveMeal))
        navigationItem.rightBarButtonItem = button
        
        navigationItem.title = "식단 쓰기"
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        mealEditView.memoTextView.rx.attributedText
            .bind(to: viewModel.memoTextView)
            .disposed(by: disposeBag)
    }
    
    @objc func saveMeal() {
        let result = viewModel.saveMeal(for: selectedDate, and: mealEditView.selectedImage)
        
        if !result {
            showAlertWithOKButton(title: "", message: "글 입력 혹은 이미지 추가를 해주세요")
        } else {
            showAlertWithOKButton(title: "", message: "저장했습니다") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
