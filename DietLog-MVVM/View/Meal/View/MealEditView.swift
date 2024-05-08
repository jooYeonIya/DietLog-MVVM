//
//  MealEditView.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/01.
//

import UIKit
import PhotosUI

protocol MealEditViewDelegate: AnyObject {
    func didTappedOpenPhotoGallayButton()
    func didTappedOpenCameraAppButton()
}

class MealEditView: UIView {
    
    // MARK: - Component
    lazy var memoTextView = UITextView()
    lazy var selectedImage: UIImage? = nil
    
    // MARK: - 변수
    weak var delegate: MealEditViewDelegate?

    func configure() {
        setupUI()
        setupLayout()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubviews([memoTextView])
        
        setupMemoTextViewUI()
    }
    
    private func setupMemoTextViewUI() {
        memoTextView.becomeFirstResponder()
        memoTextView.font = .body
        memoTextView.backgroundColor = .customGray
        
        createAccessoryView()
    }
    
    private func createAccessoryView() {
        let photoButton = UIBarButtonItem(image: UIImage(systemName: "photo"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(openPhotoGallery))
        photoButton.tintColor = .customGreen
        
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(openCameraApp))
        cameraButton.tintColor = .customGreen
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([photoButton, cameraButton], animated: true)
        memoTextView.inputAccessoryView = toolBar
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        memoTextView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - objc 메서드
    @objc func openPhotoGallery() {
        delegate?.didTappedOpenPhotoGallayButton()
    }
    
    @objc func openCameraApp() {
        delegate?.didTappedOpenCameraAppButton()
    }
}
