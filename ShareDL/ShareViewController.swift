//
//  BackgroundViewController.swift
//  ShareDL
//
//  Created by Jooyeon Kang on 2024/05/06.
//

import UIKit
import Social
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift
import UniformTypeIdentifiers
import MobileCoreServices

class ShareViewController: UIViewController {
    
    // MARK: - Component
    private lazy var backgroundView = UIView()
    private lazy var cancelButton = UIButton()
    private lazy var doneButton = UIButton()
    private lazy var selectCategoryTitleLabel = UILabel()
    private lazy var selectCategoryTableView = UITableView()
    private lazy var memoTitleLabel = UILabel()
    private lazy var memoTextView = UITextView()
    
    // MARK: - 변수
    let viewModel = SelectCategoryViewModel()
    let disposeBag = DisposeBag()
    
    var cellIsSelected = false
    var categoryId: ObjectId?
    
    var URL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        extractULR()
        
        let grayView = UIView()
        grayView.backgroundColor = .systemGray
        view.insertSubview(grayView, at: 0)
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        
        viewConfigure()
    }
    
    private func viewConfigure() {
        setupBackgroundView()
        setupUI()
        setupLayout()
        setupBinding()
        setupNotification()
    }
    
    private func setupBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.delegate = self
        backgroundView.addGestureRecognizer(tapGesture)
        
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 16
        
        backgroundView.addSubview(cancelButton)
        backgroundView.addSubview(doneButton)
        backgroundView.addSubview(selectCategoryTitleLabel)
        backgroundView.addSubview(selectCategoryTableView)
        backgroundView.addSubview(memoTitleLabel)
        backgroundView.addSubview(memoTextView)
    }
    
    private func setupUI() {
        let attributies = [NSAttributedString.Key.font: UIFont(name: "LINESeedSansKR-Regular", size: 16)]
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.345, green: 0.737, blue: 0.627, alpha: 1.0), for: .normal)
        cancelButton.addTarget(self, action: #selector(didTappedCancelButton), for: .touchUpInside)
        
        doneButton.setTitle("저장", for: .normal)
        doneButton.setTitleColor(UIColor(red: 0.345, green: 0.737, blue: 0.627, alpha: 1.0), for: .normal)
        doneButton.addTarget(self, action: #selector(didTappedDoneButton), for: .touchUpInside)
        
        selectCategoryTitleLabel.text = "카테고리 선택"
        selectCategoryTitleLabel.font = UIFont(name: "LINESeedSansKR-Bold", size: 16)
        
        selectCategoryTableView.register(SelectCategoryTableViewCell.self,
                                         forCellReuseIdentifier: "SelectCategoryTableViewCell")
        selectCategoryTableView.rowHeight = UITableView.automaticDimension
        selectCategoryTableView.separatorStyle = .none
        selectCategoryTableView.showsVerticalScrollIndicator = false
        
        memoTitleLabel.text = "메모"
        memoTitleLabel.font = UIFont(name: "LINESeedSansKR-Bold", size: 16)
        
        memoTextView.backgroundColor = .systemGray4
        memoTextView.layer.cornerRadius = 16
    }
    
    private func setupLayout() {
        backgroundView.snp.makeConstraints { make in
            make.height.equalTo(view.frame.size.height / 2)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.width.height.equalTo(52)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(52)
        }
        
        selectCategoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        selectCategoryTableView.snp.makeConstraints { make in
            make.top.equalTo(selectCategoryTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(selectCategoryTitleLabel)
            make.height.equalTo(view.frame.size.height / 2 / 4)
        }
        
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(selectCategoryTableView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(selectCategoryTitleLabel)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(selectCategoryTitleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
    
    private func setupBinding() {
        viewModel.getCategorisData()
        viewModel.categoriesData
            .bind(to: selectCategoryTableView.rx.items(cellIdentifier: "SelectCategoryTableViewCell", cellType: SelectCategoryTableViewCell.self)) { index, item, cell in
                cell.configure(with: item.title)
            }
            .disposed(by: disposeBag)
        
        selectCategoryTableView.rx.modelSelected(Category.self)
            .subscribe(onNext: { [weak self] result in
                self?.cellIsSelected = true
                self?.categoryId = result.id
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

// MARK: - 키보드 관련
extension ShareViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.3) {
                
                let height = (self.view.frame.size.height / 2) + keyboardSize.height
                
                self.backgroundView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
                
                self.memoTextView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardSize.height)
                }
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.3) {
                
                self.backgroundView.snp.updateConstraints { make in
                    make.height.equalTo(self.view.frame.size.height / 2)
                }
                
                self.memoTextView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
                }
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension ShareViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view is UITableView
    }
    
    @objc func didTappedCancelButton() {
        extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @objc func didTappedDoneButton() {
        if cellIsSelected {
            if let URL = URL {
                if URL.contains("youtube") || URL.contains("youtu.be") {
                    saveData(with: URL)
                } else {
                    showAlert(message: "Youtube 동영상만 등록할 수 있습니다")
                }
            }
        } else {
            showAlert(message: "카테고리를 선택해 주세요")
        }
    }
    
    private func extractULR(){
        if let content = extensionContext?.inputItems.first as? NSExtensionItem {
            if let contents = content.attachments {
                for attachment in contents {
                    if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (data, error) in
                            DispatchQueue.main.async {
                                if let URL = data as? URL {
                                    self.URL = URL.absoluteString
                                }
                            }
                        }
                    }

                    if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                        attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, error) in
                            DispatchQueue.main.async {
                                if let URL = data as? String {
                                    self.URL = URL
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func saveData(with url: String) {
        YoutubeService.shared.getVideoInfo(for: url)
            .subscribe(onNext: { [weak self] result in
                guard let id = self?.categoryId else { return }
                
                let exercise = Exercise()
                exercise.URL = url
                exercise.categoryID = id
                exercise.memo = self?.memoTextView.text
                exercise.thumbnailURL = result["thumbnailURL"] ?? ""
                exercise.title = result["title"] ?? ""
                ExerciseManager.shared.create(exercise)
                
                self?.showAlert(message: "저장했습니다") {
                    self?.didTappedCancelButton()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func showAlert(message: String, completion: (()->Void)? = nil) {
        let action = UIAlertAction(title: "확인", style: .default) {_ in
            completion?()
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
