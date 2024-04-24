//
//  MealEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class MealEditViewController: BaseViewController {

    // MARK: - Component
    private lazy var memoTextView = UITextView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([memoTextView])
        
        setupMemoTextViewUI()
    }
    
    private func setupMemoTextViewUI() {
        memoTextView.becomeFirstResponder()
        memoTextView.font = .body
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        memoTextView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
