//
//  ExerciseSelectCategoryViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class ExerciseSelectCategoryViewController: BaseViewController {

    // MARK: - Component
    private lazy var categoryTableView = UITableView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubview(categoryTableView)
        
        categoryTableView.register(ExerciseSelectCategoryTableViewCell.self,
                                   forCellReuseIdentifier: ExerciseSelectCategoryTableViewCell.identifier)
        categoryTableView.showsVerticalScrollIndicator = false
        categoryTableView.separatorStyle = .none
        categoryTableView.backgroundColor = .clear
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        categoryTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Setup Delegate() {
    override func setupDelegate() {
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
}

// MARK: - TableView
extension ExerciseSelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
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
        cell.configure(with: indexPath.section)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
