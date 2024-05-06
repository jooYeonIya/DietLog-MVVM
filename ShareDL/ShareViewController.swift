//
//  ShareViewController.swift
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

class ShareViewController: UIViewController {
    // MARK: - Component
    private lazy var selectCategoryTitleLabel = UILabel()
    private lazy var selectCategoryTableView = UITableView()
    private lazy var memoTitleLabel = UILabel()
    private lazy var memoTextView = UITextView()
    
    // MARK: - 변수
    let viewModel = SelectCategoryViewModel()
    let disposeBag = DisposeBag()
    
    var cellIsSelected = false
    var categoryId: ObjectId?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
            
        view.addSubview(selectCategoryTitleLabel)
        view.addSubview(selectCategoryTableView)
        view.addSubview(memoTitleLabel)
        view.addSubview(memoTextView)
        
        setNavigationBar()
        setUI()
        setLayout()
        setBinding()
    }
    
    private func setNavigationBar() {

        let attributies = [NSAttributedString.Key.font: UIFont(name: "LINESeedSansKR-Regular", size: 16)]
        
        let doneButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTappedDoneButton))
        doneButton.tintColor = UIColor(red: 0.345, green: 0.737, blue: 0.627, alpha: 1.0)
        doneButton.setTitleTextAttributes(attributies as [NSAttributedString.Key : Any], for: .normal)
        navigationItem.rightBarButtonItem = doneButton
        
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTappedCancelButton))
        cancelButton.tintColor = UIColor(red: 0.345, green: 0.737, blue: 0.627, alpha: 1.0)
        cancelButton.setTitleTextAttributes(attributies as [NSAttributedString.Key : Any], for: .normal)
        navigationItem.leftBarButtonItem = cancelButton
    }

    private func setUI() {
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
    
    private func setBinding() {
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
    
    private func setLayout() {
        selectCategoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        selectCategoryTableView.snp.makeConstraints { make in
            make.top.equalTo(selectCategoryTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(selectCategoryTitleLabel)
            make.height.equalTo(view.snp.height).dividedBy(3)
        }
        
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(selectCategoryTableView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(selectCategoryTitleLabel)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(selectCategoryTitleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension ShareViewController {
    
    @objc func didTappedCancelButton() {
        extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    @objc func didTappedDoneButton() {
        if cellIsSelected {
            saveData()
        } else {
            showAlert(message: "카테고리를 선택해 주세요")
        }
    }
    
    private func saveData(){
        var url = "https://youtube.com"
        guard let contextItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        
        guard let provider = contextItem.attachments?.first as? NSItemProvider else { return }
        
        provider.loadItem(forTypeIdentifier: "public.url", options: nil) { result, error in
            if let shareULR = result as? URL {
                url = shareULR.absoluteString
            }
        }
        
        YoutubeService.shared.getVideoInfo(for: url)
            .subscribe(onNext: { [weak self] result in
                guard let id = self?.categoryId else { return }
                
                let exercise = Exercise()
                exercise.URL = url
                exercise.categoryID = id
                exercise.memo = self?.memoTextView.text
                exercise.thumbnailURL = result["thumbnailURL"] ?? ""
                exercise.title = result["title"] ?? ""
                ExerciseManager.shared.addExercise(exercise)
                
                self?.showAlert(message: "저장했습니다")
                self?.didTappedCancelButton()
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert(message: String) {
        let action = UIAlertAction(title: "확인", style: .default)
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}