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
    private lazy var recentWordCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(RecentWordCollectionViewCell.self, forCellWithReuseIdentifier: RecentWordCollectionViewCell.identified)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.configure(text: SearchViewText.result.rawValue , font: .title)
        return label
    }()
    
    private lazy var recentWordLabel = UILabel()
    private lazy var recentWordAllDeleteButton = UIButton()
    private lazy var segmentedControl = UISegmentedControl(items: ["메모", "URL"])
    private lazy var underlineView = UIView()
    private lazy var resultTableView = UITableView()
    
    // MARK: - 변수
    var recentWords: [String] = ["최근", "검색어", "최근 검색어"]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([recentWordLabel, 
                          recentWordCollectionView,
                          recentWordAllDeleteButton,
                          resultLabel,
                          segmentedControl,
                          underlineView,
                          resultTableView])
        
        setupSearchBarUI()
        setupRecentWordSectionUI()
        setupSegmentedControlUI()
        setupResultTableViewUI()
    }
    
    private func setupSearchBarUI() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupRecentWordSectionUI() {
        recentWordLabel.configure(text: SearchViewText.recentWord.rawValue, font: .title)
        recentWordLabel.textColor = .black
        
        recentWordAllDeleteButton.setTitle("전체 삭제", for: .normal)
        recentWordAllDeleteButton.setTitleColor(.systemGray, for: .normal)
        recentWordAllDeleteButton.titleLabel?.font = .smallBody
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
        recentWordLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
            make.trailing.lessThanOrEqualTo(recentWordAllDeleteButton.snp.leading)
        }
        
        recentWordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentWordLabel.snp.bottom).offset(12)
            make.leading.equalTo(recentWordLabel)
            make.trailing.equalTo(recentWordAllDeleteButton)
            make.height.equalTo(24)
        }
        
        recentWordAllDeleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentWordLabel)
            make.trailing.equalToSuperview().offset(-Padding.leftRightSpacing.rawValue)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(recentWordCollectionView.snp.bottom).offset(24)
            make.leading.equalTo(recentWordLabel.snp.leading)
            make.trailing.equalTo(recentWordAllDeleteButton.snp.trailing)
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
        recentWordCollectionView.dataSource = self
        recentWordCollectionView.delegate = self
        
        resultTableView.dataSource = self
        resultTableView.delegate = self
    }
}

// MARK: - SerachBar
extension SearchViewController: UISearchBarDelegate {
    
}

// MARK: - CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentWordCollectionViewCell.identified, for: indexPath) as? RecentWordCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(text: recentWords[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = recentWords[indexPath.row]
        let textAttributes = [NSAttributedString.Key.font: UIFont.smallBody]
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width
        
        let delegateButtonWidth: CGFloat = 20
        let spacing: CGFloat = (8 * 2) + 4
        
        let width = textWidth + delegateButtonWidth + spacing
        
        return CGSize(width: width, height: 20)
    }
}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else { return UITableViewCell() }
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
