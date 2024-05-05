//
//  SearchViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

enum SearchViewText: String {
    case recentWord = "최근 검색어"
    case result = "검색 결과"
}

class SearchViewController: BaseViewController {
    
    // MARK: - Component
    private lazy var recentSearchView = RecentSearchView()
    
    private lazy var resultLabel = UILabel()
    private lazy var segmentedControl = UISegmentedControl(items: ["메모", "URL"])
    private lazy var underlineView = UIView()
    private lazy var resultTableView = UITableView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayTopView(false)
        recentSearchView.configure()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([recentSearchView,
                          resultLabel,
                          segmentedControl,
                          underlineView,
                          resultTableView])
        
        resultLabel.configure(text: SearchViewText.result.rawValue , font: .title)

        setupSearchBarUI()
        setupSegmentedControlUI()
        setupResultTableViewUI()
    }
    
    private func setupSearchBarUI() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupSegmentedControlUI() {
        segmentedControl.setBackgroundWhiteImage()
        underlineView.backgroundColor = .customYellow
    }
    
    private func setupResultTableViewUI() {
        resultTableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: ExerciseTableViewCell.identifier)
        resultTableView.showsVerticalScrollIndicator = false
        resultTableView.separatorStyle = .none
        resultTableView.backgroundColor = .clear
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
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

    // MARK: - Setup Delegate
    override func setupDelegate() {
        resultTableView.dataSource = self
        resultTableView.delegate = self
    }
}

// MARK: - SerachBar
extension SearchViewController: UISearchBarDelegate {
    
}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else { return UITableViewCell() }
//        cell.configure(
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
