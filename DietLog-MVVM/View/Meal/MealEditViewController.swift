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
        
        createAccessoryView()
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        memoTextView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - 메서드
extension MealEditViewController {
    @objc func openPhotoGallery() {
        insertImageIntoTextView(UIImage(systemName: "photo")!)

    }
    
    @objc func openCamera() {
        insertImageIntoTextView(UIImage(systemName: "heart")!)
    }
    
    private func createAccessoryView() {
        let photoButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(openPhotoGallery))
        photoButton.tintColor = .customGreen
        
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(openCamera))
        cameraButton.tintColor = .customGreen
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([photoButton, cameraButton], animated: true)
        memoTextView.inputAccessoryView = toolBar
    }
    
    private func insertImageIntoTextView(_ image: UIImage) {
        let memoTextViewWidth = memoTextView.frame.size.width
        let imageWidth = image.size.width
        
        let textAttachment = NSTextAttachment()
        
        if imageWidth > memoTextViewWidth {
            let scale = imageWidth / (memoTextViewWidth - 12)
            textAttachment.image = UIImage(cgImage: image.cgImage!, scale: scale, orientation: .up)
        } else {
            textAttachment.image = image
        }
        
        let attributedStringWithImage = NSAttributedString(attachment: textAttachment)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(attributedStringWithImage)
        
        memoTextView.attributedText = attributedString
    }
}
