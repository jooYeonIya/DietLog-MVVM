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
        view.addSubviews([noDataLabel,
                          calendarBackgroundView,
                          mealsDataTableView,
                          floatingButton])
        
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
        mealsDataTableView.rowHeight = 100
    }
    
    private func setupFloatingButtoUI() {
        floatingButton.configureFloatingButton(width:CGFloat(ComponentSize.floatingButton.rawValue))
    }
    
    private func setupNoDataLabelUI() {
        noDataLabel.configure(text: LocalizedText.plusData, font: .body)
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        calendarBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.height.equalTo(ComponentSize.calendarHeight.rawValue)
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
            make.centerY.equalTo(mealsDataTableView)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        calendarView.dataSource = self
        calendarView.delegate = self
    }
    
    // MARK: - Setup Event
    override func setupEvent() {
        floatingButton.addTarget(self, action: #selector(moveToMealEditView), for: .touchUpInside)
    }
    
    override func setupBinding() {
        viewModel.mealsData
            .observe(on: MainScheduler.instance)
            .bind(to: mealsDataTableView.rx.items(cellIdentifier: MealsDataTableViewCell.identifier,
                                                  cellType: MealsDataTableViewCell.self)) { [weak self] index, item, cell in
                if let imageName = item.imageName {
                    cell.configure(with: self?.viewModel.findImage(byName: imageName))
                } else {
                    cell.configure(with: UIImage(named: "MealBasicImage"))
                }

                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        viewModel.mealsData
            .subscribe(onNext: { [weak self] mealsData in
                let hasData = mealsData.isEmpty
                
                self?.noDataLabel.isHidden = !hasData
                self?.mealsDataTableView.isHidden = hasData
            })
            .disposed(by: disposeBag)
        
        mealsDataTableView.rx.modelSelected(Meal.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                let viewController = MealReadAndModifyEditViewController(selectedDate: self.selectedDate, mealId: item.id)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 메서드
extension MealViewController {
    @objc func moveToMealEditView() {
        let viewController = MealCreateEditViewController(selectedDate: selectedDate)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func reloadData() {
        viewModel.findMealsData(byDate: selectedDate)
        mealsDataTableView.reloadData()
    }
}

// MARK: - FSCalendar
extension MealViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        reloadData()
    }
}
