//
//  MealEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import PhotosUI

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
        memoTextView.backgroundColor = .customGray
        
        createAccessoryView()
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        memoTextView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
        
        navigationItem.title = "식단 쓰기"
    }
}

// MARK: - 메서드
extension MealEditViewController {
    @objc func openPhotoGallery() {

        guard !isContainsImage(in: memoTextView) else {
            showAlertWithOKButton(title: "", message: "사진은 한 장만 저장이 가능합니다\n먼저 사진을 삭제해 주세요")
            return
        }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = self
        present(viewController, animated: true)
        
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
            let scale = imageWidth / (memoTextViewWidth - 24)
            textAttachment.image = UIImage(cgImage: image.cgImage!, scale: scale, orientation: .up)
        } else {
            textAttachment.image = image
        }
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(NSAttributedString(attachment: textAttachment))
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: attributedString.length))
        
        memoTextView.attributedText = attributedString
    }
    
    private func isContainsImage(in textView: UITextView) -> Bool {
        
        guard let attributedText = textView.attributedText else { return false }
        
        let range = NSRange(location: 0, length: attributedText.length)
        
        var isCntainsImage = false
        
        attributedText.enumerateAttribute(.attachment, in: range) { value, range, pointer in
            if let attachment = value as? NSTextAttachment, attachment.image != nil {
                pointer.pointee = true
                isCntainsImage = true
            }
        }
        
        return isCntainsImage
    }
}

// MARK: - PHPickerView
extension MealEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let selectedImage = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self.insertImageIntoTextView(selectedImage)
                }
            }
        }
    }
}
