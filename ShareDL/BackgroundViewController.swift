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

class BackgroundViewController: UIViewController {
    
    // MARK: - Component
    private lazy var mainView = UIView()
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
    
    var urlSubject = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let grayView = UIView()
        grayView.backgroundColor = .systemGray
        view.insertSubview(grayView, at: 0)
        view.backgroundColor = .clear
        view.addSubview(mainView)
        
        viewConfigure()
    }
    
    private func viewConfigure() {
        setupMainView()
        setupUI()
        setupLayout()
        setupBinding()
        setupNotification()
    }
    
    private func setupMainView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.delegate = self
        mainView.addGestureRecognizer(tapGesture)
        
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 16
        
        mainView.addSubview(cancelButton)
        mainView.addSubview(doneButton)
        mainView.addSubview(selectCategoryTitleLabel)
        mainView.addSubview(selectCategoryTableView)
        mainView.addSubview(memoTitleLabel)
        mainView.addSubview(memoTextView)
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
        mainView.snp.makeConstraints { make in
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
extension BackgroundViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.3) {
                
                let height = (self.view.frame.size.height / 2) + keyboardSize.height
                
                self.mainView.snp.updateConstraints { make in
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
                
                self.mainView.snp.updateConstraints { make in
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

extension BackgroundViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view is UITableView
    }
    
    @objc func didTappedCancelButton() {
        extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @objc func didTappedDoneButton() {
        if cellIsSelected {
            getULR()
            urlSubject.subscribe(onNext: { [weak self] url in
                self?.saveData(with: url)
            }).disposed(by: disposeBag)
        } else {
            showAlert(message: "카테고리를 선택해 주세요")
        }
    }
    
    private func getULR() {
        guard let contextItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let provider = contextItem.attachments?.first as? NSItemProvider else { return }
        provider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] result, error in
            if let shareULR = result as? URL {
                
                DispatchQueue.main.async {
                    self?.urlSubject.onNext(shareULR.absoluteString)
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
