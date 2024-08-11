//
//  ExerciseViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import RxSwift
import RealmSwift

class ExerciseViewController: BaseViewController {

    // MARK: - Component
    private lazy var exerciseDataTableView = UITableView()
    private lazy var noDataLabel = UILabel()
    private lazy var playerView = UIView()
    
    // MARK: - 변수
    private var exerciseData: [Exercise] = []
    private let viewModel = ExerciseViewModel()
    private let disposeBag = DisposeBag()
    private let categoryId: ObjectId?
    
    // MARK: - 초기화
    init(categoryId: ObjectId) {
        self.categoryId = categoryId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    private func reloadData() {
        if let categoryId = categoryId {
            viewModel.findExerciseData(by: categoryId)
            exerciseDataTableView.reloadData()
        }
        
        let hasData = !exerciseData.isEmpty
        exerciseDataTableView.isHidden = !hasData
        playerView.isHidden = !hasData
        noDataLabel.isHidden = hasData
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([playerView, exerciseDataTableView, noDataLabel])
        
        exerciseDataTableView.separatorStyle = .none
        exerciseDataTableView.backgroundColor = .clear
        exerciseDataTableView.showsVerticalScrollIndicator = false
        exerciseDataTableView.register(ExerciseTableViewCell.self,
                                       forCellReuseIdentifier: ExerciseTableViewCell.identifier)
        
        noDataLabel.configure(text: LocalizedText.plusData, font: .body)
        
        playerView.backgroundColor = .orange
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        playerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
            make.height.equalTo(playerView.snp.width).multipliedBy(9.0/16.0)
        }
        
        exerciseDataTableView.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        noDataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        exerciseDataTableView.dataSource = self
        exerciseDataTableView.delegate = self
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        viewModel.exerciseData
            .subscribe { [weak self] result in
                self?.exerciseData = result
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView
extension ExerciseViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return exerciseData.count
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else { return UITableViewCell() }
        
        viewModel.findThumbnailImage(with: exerciseData[indexPath.section].thumbnailURL)
            .subscribe(onNext: { image in
                cell.thumbnailImageView.image = image
            }).disposed(by: disposeBag)
                
        cell.configure(exercise: exerciseData[indexPath.section])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - 옵션 수정 삭제
extension ExerciseViewController: ExerciseTableViewCellDelegate {
    func didTappedOptionButton(_ cell: ExerciseTableViewCell) {
        guard let indexPath = exerciseDataTableView.indexPath(for: cell) else { return }
        let exercise = exerciseData[indexPath.row]
        
        showOptionMenuSheet {
            self.moveToModifyView(exercise)
        } deleteCompletion: {
            self.showAlertTwoButton(title: "", message: LocalizedText.willDelete, actionCompletion: {
                self.deleteExercise(exercise)
            })
        }
    }
    
    private func moveToModifyView(_ exercise: Exercise) {
        let viewController = ExerciseModifyEditViewController()
        viewController.exercise = exercise
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func deleteExercise(_ exercise: Exercise) {
        viewModel.remove(exercise)
        
        showAlertWithOKButton(title: "", message: LocalizedText.didDelete) {
            self.reloadData()
        }
    }
}
