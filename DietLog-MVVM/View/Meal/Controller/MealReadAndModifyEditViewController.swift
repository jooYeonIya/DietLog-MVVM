//
//  MealReadAndModifyEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/01.
//

import UIKit
import RealmSwift
import RxSwift

class MealReadAndModifyEditViewController: MealEditViewController {

    // MARK: - 변수
    private var selectedDate: Date?
    private var mealId: ObjectId?
    private var mealData: Meal?
    private var viewModel = MealEditViewModel()
    private var disposeBag = DisposeBag()
    
    private var isEditable: Bool = false {
        willSet {
            mealEditView.memoTextView.isEditable = newValue
            
            if newValue {
                mealEditView.memoTextView.becomeFirstResponder()
            } else {
                mealEditView.memoTextView.resignFirstResponder()
            }
        }
    }

    // MARK: - 초기화
    init(selectedDate: Date, mealId: ObjectId) {
        super.init(nibName: nil, bundle: nil)
        self.selectedDate = selectedDate
        self.mealId = mealId
    }
    
    // MARK: - Life Cylce
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadMealData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(image: UIImage(named: "OptionMenu"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(openOptionMenu))
        navigationItem.rightBarButtonItem = button
        
        navigationItem.title = "내 식단"
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        mealEditView.memoTextView.rx.attributedText
            .bind(to: viewModel.memoTextView)
            .disposed(by: disposeBag)
        
        viewModel.mealData
            .subscribe { [weak self] result in
                self?.mealData = result
            }
            .disposed(by: disposeBag)
    }
    
    private func reloadMealData() {
        if let mealId = mealId {
            viewModel.getMealData(with: mealId)
        }
        
        updateUI()
        
        isEditable = false
    }
    
    private func updateUI() {
        guard let mealData = mealData else { return }
        
        DispatchQueue.main.async {
            self.mealEditView.memoTextView.text = mealData.memo

            let image = ImageFileManager.shared.loadImage(with: mealData.imageName!)
            self.insertImageIntoTextView(image ?? UIImage(named: "FoodBasicImage")!)
        }
    }
}

// Modify, Delete
extension MealReadAndModifyEditViewController {
    @objc func openOptionMenu() {
        showOptionMenuSheet(modifyCompletion: {
            self.modifyMealData()
        }, deleteCompletion: {
            self.deleteMealData()
        })
    }
    
    private func modifyMealData() {
        
    }
    
    private func deleteMealData() {
        guard let mealData = mealData else { return }
        viewModel.deleteMealData(mealData)
        
        showAlertWithOKButton(title: "", message: "삭제했습니다") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
