//
//  ExerciseSelectCategoryViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import RxSwift

class ExerciseSelectCategoryViewController: BaseViewController {

    // MARK: - Component
    private lazy var addCategoryButton = UIButton()
    private lazy var categoryTableView = UITableView()
    
    // MARK: - 변수
    private let viewModel = SelectCategoryViewModel()
    private let disposeBag = DisposeBag()
    private var categoriesData: [Category] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    private func reloadData() {
        viewModel.getCategorisData()
        categoryTableView.reloadData()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([addCategoryButton, categoryTableView])
        
        setupAddCategoryButton()
        setupTableViewUI()
    }
    
    private func setupAddCategoryButton() {
        addCategoryButton.applyRadius()
        addCategoryButton.applyShadow()
        addCategoryButton.tintColor = .white
        addCategoryButton.backgroundColor = .systemGray
        
        let buttonImage = UIImage(systemName: "plus",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        addCategoryButton.setImage(buttonImage, for: .normal)
    }
    
    private func setupTableViewUI() {
        categoryTableView.register(ExerciseSelectCategoryTableViewCell.self,
                                   forCellReuseIdentifier: ExerciseSelectCategoryTableViewCell.identifier)
        categoryTableView.showsVerticalScrollIndicator = false
        categoryTableView.separatorStyle = .none
        categoryTableView.backgroundColor = .clear
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        addCategoryButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.height.equalTo(40)
        }
        
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(addCategoryButton.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Setup Delegate() {
    override func setupDelegate() {
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        viewModel.categoriesData
            .subscribe { [weak self] result in
                self?.categoriesData = result
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView
extension ExerciseSelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesData.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .customGray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseSelectCategoryTableViewCell.identifier, for: indexPath) as? ExerciseSelectCategoryTableViewCell else { return UITableViewCell() }
        cell.configure(with: categoriesData[indexPath.section].title)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
