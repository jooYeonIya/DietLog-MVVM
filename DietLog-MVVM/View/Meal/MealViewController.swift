//
//  MealViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import FSCalendar

class MealViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var calendarView = FSCalendar()
    private lazy var calendarBackgroundView = UIView()
    private lazy var mealsDataTableView = UITableView()
    private lazy var floatingButton = UIButton()
    
    // MARK: - 변수
    // 임시
    private var mealsData: [UIImage] = [UIImage(named: "MealBasicImage")!]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(true)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([calendarBackgroundView,
                          mealsDataTableView,
                          floatingButton])
        
        setupCalendarViewUI()
        setupTableViewUI()
        setupFloatingButtoUI()
    }
    
    private func setupCalendarViewUI() {
        calendarView.configure()
        
        calendarBackgroundView.addSubview(calendarView)
        calendarBackgroundView.backgroundColor = .white
        calendarBackgroundView.applyRadius()
        calendarBackgroundView.applyShadow()
    }
    
    private func setupTableViewUI() {
        mealsDataTableView.register(MealsDataTableViewCell.self,
                                    forCellReuseIdentifier: MealsDataTableViewCell.identifier)
        
        mealsDataTableView.separatorStyle = .none
        mealsDataTableView.backgroundColor = .clear
        mealsDataTableView.showsVerticalScrollIndicator = false
    }
    
    private func setupFloatingButtoUI() {
        floatingButton.configureFloatingButton(width:CGFloat(ComponentSize.floatingButton.rawValue))
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        calendarBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.height.equalTo(360)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        mealsDataTableView.snp.makeConstraints { make in
            make.top.equalTo(calendarBackgroundView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(calendarBackgroundView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalTo(calendarBackgroundView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.width.height.equalTo(ComponentSize.floatingButton.rawValue)
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        mealsDataTableView.dataSource = self
        mealsDataTableView.delegate = self
    }
    
    // MARK: - Set
    override func setupEvent() {
        floatingButton.addTarget(self, action: #selector(moveToMealEditView), for: .touchUpInside)
    }
}

// MARK: - 메서드
extension MealViewController {
    @objc func moveToMealEditView() {
        let viewController = MealEditViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - TableView DataSource
extension MealViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealsDataTableViewCell.identifier, for: indexPath) as? MealsDataTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: mealsData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
