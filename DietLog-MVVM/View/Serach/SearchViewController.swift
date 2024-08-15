//
//  SearchViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import RxSwift
import RxCocoa

enum SearchViewText: String {
    case recentWord = "최근 검색어"
    case result = "검색 결과"
}

class SearchViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var recentSearchView = RecentSearchView()
    
    private lazy var searchBar = UISearchBar()
    
    private lazy var resultLabel = UILabel()
    private lazy var segmentedControl = UISegmentedControl(items: [SearchSegmentOption.title.title,
                                                                   SearchSegmentOption.memo.title])
    private lazy var underlineView = UIView()
    private lazy var resultTableView = UITableView()
    private lazy var noDataLabel = UILabel()
    
    // MARK: - 변수
    private var reusltData: Exercise?
    private let viewModel = ExerciseViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayTopView(false)
        recentSearchView.configure()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([noDataLabel,
                          recentSearchView,
                          resultLabel,
                          segmentedControl,
                          underlineView,
                          resultTableView])
        
        resultLabel.configure(text: SearchViewText.result.rawValue , font: .title)
        noDataLabel.configure(text: "데이터가 없습니다", font: .body)

        setupSearchBarUI()
        setupSegmentedControlUI()
        setupResultTableViewUI()
    }
    
    private func setupSearchBarUI() {
        navigationItem.titleView = searchBar
    }
    
    private func setupSegmentedControlUI() {
        let textAttributes = [NSAttributedString.Key.font: UIFont.body]
        segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
        segmentedControl.setBackgroundWhiteImage()
        segmentedControl.selectedSegmentIndex = 0
        underlineView.backgroundColor = .customYellow
    }
    
    private func setupResultTableViewUI() {
        resultTableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: ExerciseTableViewCell.identifier)
        resultTableView.showsVerticalScrollIndicator = false
        resultTableView.separatorStyle = .none
        resultTableView.backgroundColor = .clear
        resultTableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        noDataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        recentSearchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.height.equalTo(80)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(recentSearchView)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(resultLabel)
            make.height.equalTo(40)
        }
        
        underlineView.snp.makeConstraints { make in
            let width = view.frame.width - CGFloat(Padding.leftRightSpacing.rawValue * 2)
            
            make.width.equalTo(width / 2)
            make.height.equalTo(2)
            
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.equalTo(segmentedControl.snp.leading)
        }
        
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalTo(resultLabel)
        }
    }

    // MARK: - Setup Bind
    override func setupBinding() {
        viewModel.exerciseData
            .observe(on: MainScheduler.instance)
            .bind(to: resultTableView.rx.items(cellIdentifier: ExerciseTableViewCell.identifier, cellType: ExerciseTableViewCell.self)) { [weak self] index, item, cell in

                guard let self = self else { return }

                self.reusltData = item
                
                self.viewModel.findThumbnailImage(with: item.thumbnailURL)
                    .subscribe(onNext: { image in
                        cell.thumbnailImageView.image = image
                    }).disposed(by: self.disposeBag)
                
                cell.configure(exercise: item)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        resultTableView.rx.modelSelected(Exercise.self)
            .subscribe { [weak self] item in

            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe { [weak self] _ in
                if let searchText = self?.searchBar.text, !searchText.isEmpty {
                    self?.reloadData(with: searchText)
                    self?.recentSearchView.viewModel.saveRecentSearchWord(with: searchText)
                    self?.recentSearchView.reloadData()
                }
                self?.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .skip(1)
            .subscribe { [weak self] index in
                self?.changeSegmentedControlUnderline(index: CGFloat(index))
                self?.reloadData(with: self?.searchBar.text)
            }
            .disposed(by: disposeBag)
        
        recentSearchView.recentWordCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] text in
                self?.searchBar.text = text
                self?.reloadData(with: text)
            })
            .disposed(by: disposeBag)
        
        recentSearchView.viewModel.searchBar
            .subscribe(onNext:  { [weak self] _ in
                self?.searchBar.text = nil
            })
            .disposed(by: disposeBag)
    }
    
    private func reloadData(with searchWord: String?) {
        guard let column = SearchSegmentOption(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        viewModel.findExerciseData(at: column, with: searchWord)
    }
    
    private func changeSegmentedControlUnderline(index: CGFloat) {
        let segmentWidth = segmentedControl.frame.width / 2
        let leadingDistance = segmentWidth * index
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.underlineView.snp.updateConstraints({ make in
                make.leading.equalTo(self!.segmentedControl.snp.leading).offset(leadingDistance)
            })
            
            self?.underlineView.superview?.layoutIfNeeded()
        })
    }
}


// MARK: - 옵션 수정 삭제
extension SearchViewController: ExerciseTableViewCellDelegate {
    func didTappedOptionButton(_ cell: ExerciseTableViewCell) {
        guard let exercise = reusltData else { return }

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
            self.reloadData(with: nil)
        }
    }
}
