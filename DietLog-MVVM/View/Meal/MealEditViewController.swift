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
    private lazy var memoTextView = UITextView()
    private lazy var selectedImage: UIImage? = nil
    
    // MARK: - 변수
    private var viewModel = MealEditViewModel()
    private var selectedDate = Date()
    private var disposeBag = DisposeBag()
    
    // MARK: - 초기화
    init(selectedDate: Date) {
        super.init(nibName: nil, bundle: nil)
        self.selectedDate = selectedDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveMeal))
        navigationItem.rightBarButtonItem = button
        
        navigationItem.title = "식단 쓰기"
    }
    
    override func setupBinding() {
        memoTextView.rx.attributedText
            .bind(to: viewModel.memoTextView)
            .disposed(by: disposeBag)
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
    
    @objc func saveMeal() {
        let result = viewModel.saveMeal(for: selectedDate, and: selectedImage)
        
        if !result {
            showAlertWithOKButton(title: "", message: "글 입력 혹은 이미지 추가를 해주세요")
        } else {
            showAlertWithOKButton(title: "", message: "저장했습니다") {
                self.navigationController?.popViewController(animated: true)
            }
        }
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
        
        var attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(NSAttributedString(attachment: textAttachment))
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: attributedString.length))

        let existingAttributedString = NSMutableAttributedString(attributedString: memoTextView.attributedText ?? NSAttributedString())
        existingAttributedString.append(attributedString)
        existingAttributedString.append(NSAttributedString(string: "\n"))
        
        memoTextView.attributedText = existingAttributedString
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
                    self.selectedImage = selectedImage
                }
            }
        }
    }
}

// MARK: - UIIMagePickerView
extension MealEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        memoTextView.becomeFirstResponder()
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        DispatchQueue.main.async {
            self.insertImageIntoTextView(image)
            self.selectedImage = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        memoTextView.becomeFirstResponder()
    }
}
