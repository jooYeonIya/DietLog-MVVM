//
//  MealEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import PhotosUI
import RxSwift

class MealEditViewController: BaseViewController {

    // MARK: - Component
    lazy var mealEditView = MealEditView()

    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = mealEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
        
        mealEditView.configure()
        mealEditView.delegate = self
    }
}

// MARK: - 메서드
extension MealEditViewController {
    func insertImageIntoTextView(_ image: UIImage) {
        let attributedString = NSMutableAttributedString()

        // 기존 텍스트가 있으면 추가
        if !mealEditView.memoTextView.attributedText.string.isEmpty {
            let existingText = NSMutableAttributedString(attributedString: mealEditView.memoTextView.attributedText)
            attributedString.append(existingText)
        }

        // 이미지 사이즈 조정
        let memoTextViewWidth = mealEditView.memoTextView.frame.size.width
        let imageWidth = image.size.width
        let textAttachment = NSTextAttachment()
        
        if imageWidth > memoTextViewWidth {
            let scale = imageWidth / (memoTextViewWidth - 12)
            textAttachment.image = UIImage(cgImage: image.cgImage!, scale: scale, orientation: .up)
        } else {
            textAttachment.image = image
        }

        // 이미지 중앙 정렬
        let imageText = NSAttributedString(attachment: textAttachment)
        attributedString.append(imageText)

        attributedString.addAttributes([.font: UIFont.preferredFont(forTextStyle: .body)], 
                                       range: NSRange(location: 0, length: attributedString.length))

        // 결과를 TextView에 설정
        mealEditView.memoTextView.attributedText = attributedString
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
    
    private func displaySettingsApp() {
        let alertController = UIAlertController(title: "접근 권한 설정 필요",
                                                message: "카메라에 대한 권한 설정을 해주세요",
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsAppURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsAppURL)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(action)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
}

// MARK: - MealEditView
extension MealEditViewController: MealEditViewDelegate {
    func didTappedOpenPhotoGallayButton() {
        guard !isContainsImage(in: mealEditView.memoTextView) else {
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
    
    func didTappedOpenCameraAppButton() {
        AVCaptureDevice.requestAccess(for: .video) { result in
            if result {
                DispatchQueue.main.async {
                    let viewControlle = UIImagePickerController()
                    viewControlle.sourceType = .camera
                    viewControlle.allowsEditing = false
                    viewControlle.delegate = self
                    self.present(viewControlle, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.displaySettingsApp()
                }
            }
        }
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
                    self.mealEditView.selectedImage = selectedImage
                }
            }
        }
    }
}

// MARK: - UIIMagePickerView
extension MealEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        mealEditView.memoTextView.becomeFirstResponder()
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        DispatchQueue.main.async {
            self.insertImageIntoTextView(image)
            self.mealEditView.selectedImage = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        mealEditView.memoTextView.becomeFirstResponder()
    }
}
