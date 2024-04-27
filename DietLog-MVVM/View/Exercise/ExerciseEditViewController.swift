//
//  ExerciseEditViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

enum ExerciseEditOption: Int {
    case URL, category, memo
}

class ExerciseEditViewController: BaseViewController {
    
    // MARK: - Componente
    private lazy var exerciseEditTableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubview(exerciseEditTableView)
        
        setupTableViewUI()
    }
    
    private func setupTableViewUI() {
        exerciseEditTableView.register(ExerciseEditTableViewCell.self,
                                       forCellReuseIdentifier: ExerciseEditTableViewCell.indetifier)
        exerciseEditTableView.register(ExerciseEditTextFieldTableViewCell.self,
                                       forCellReuseIdentifier: ExerciseEditTextFieldTableViewCell.indetifier)
        exerciseEditTableView.register(ExerciseEditTextViewTableViewCell.self,
                                       forCellReuseIdentifier: ExerciseEditTextViewTableViewCell.indetifier)
        exerciseEditTableView.showsVerticalScrollIndicator = false
        exerciseEditTableView.backgroundColor = .clear
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        exerciseEditTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        exerciseEditTableView.dataSource = self
        exerciseEditTableView.delegate = self
    }
    
    // MARK: - Setup NavigationBar
    override func setupNavigationBar() {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = button
    }
}

// MARK: - TableView
extension ExerciseEditViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .customGray
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .customGray
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == ExerciseEditOption.URL.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseEditTextFieldTableViewCell.indetifier) as? ExerciseEditTextFieldTableViewCell {
                cell.configure()
                cell.selectionStyle = .none
                return cell
            }
        } else if section == ExerciseEditOption.category.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseEditTableViewCell.indetifier) as? ExerciseEditTableViewCell {
                cell.configure()
                cell.selectionStyle = .none
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseEditTextViewTableViewCell.indetifier) as? ExerciseEditTextViewTableViewCell {
                cell.configure()
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == ExerciseEditOption.category.rawValue {
            let viewController = ExerciseSelectCategoryViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
