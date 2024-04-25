//
//  ExerciseViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class ExerciseViewController: BaseViewController {

    // MARK: - Component
    private lazy var exerciseDataTableView = UITableView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubview(exerciseDataTableView)
        exerciseDataTableView.separatorStyle = .none
        exerciseDataTableView.backgroundColor = .clear
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        exerciseDataTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        exerciseDataTableView.dataSource = self
        exerciseDataTableView.delegate = self
    }
}

// MARK: - TableView DataSource
extension ExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate
extension ExerciseViewController: UITableViewDelegate {
    
}
