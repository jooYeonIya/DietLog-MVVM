//
//  MealViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import FSCalendar
import RxSwift

class MealViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var calendarView = FSCalendar()
    private lazy var calendarBackgroundView = UIView()
    private lazy var mealsDataTableView = UITableView()
    private lazy var floatingButton = UIButton()
    private lazy var noDataLabel = UILabel()
    
    // MARK: - 변수
    private var mealsData: [Meal] = []
    private var selectedDate = Date.now
    private var viewModel = MealViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([calendarBackgroundView,
                          mealsDataTableView,
                          floatingButton,
                          noDataLabel])
        
        setupCalendarViewUI()
        setupTableViewUI()
        setupFloatingButtoUI()
        setupNoDataLabelUI()
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
    
    private func setupNoDataLabelUI() {
        noDataLabel.configure(text: "데이터를 기록해 주세요", font: .body)
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
        
        noDataLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarBackgroundView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        mealsDataTableView.dataSource = self
        mealsDataTableView.delegate = self
        
        calendarView.dataSource = self
        calendarView.delegate = self
    }
    
    // MARK: - Setup Event
    override func setupEvent() {
        floatingButton.addTarget(self, action: #selector(moveToMealEditView), for: .touchUpInside)
    }
    
    override func setupBinding() {
        viewModel.mealsData
            .subscribe { [weak self] result in
                guard let result = result else { return }
                self?.mealsData = result
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 메서드
extension MealViewController {
    @objc func moveToMealEditView() {
        let viewController = MealEditViewController(selectedDate: selectedDate)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func reloadData() {
        viewModel.getMealsData(for: selectedDate)
        mealsDataTableView.reloadData()
        let hasData = !mealsData.isEmpty
        mealsDataTableView.isHidden = !hasData
        noDataLabel.isHidden = hasData
    }
}

// MARK: - TableView DataSource
extension MealViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealsDataTableViewCell.identifier, for: indexPath) as? MealsDataTableViewCell else { return UITableViewCell() }
        
        guard let imageName = mealsData[indexPath.row].imageName else { return UITableViewCell() }
        cell.configure(with: viewModel.getImgae(with: imageName))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - FSCalendar
extension MealViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        reloadData()
    }
}
