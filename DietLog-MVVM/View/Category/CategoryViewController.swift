//
//  CategoryViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class CategoryViewController: BaseViewController {

    // MARK: - Component
    private lazy var categoryCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = cellSpacing
        flowlayout.minimumInteritemSpacing = cellSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.register(CategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - 변수
    private let cellSpacing: CGFloat = 16
    private var categoiesData: [String] = ["category test"]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([categoryCollectionView])
        
        setupSearchBarUI()
    }
    
    private func setupSearchBarUI() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        categoryCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
}

// MARK: - SearchBar
extension CategoryViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CollerctionView DataSource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoiesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: categoiesData[indexPath.row])
        return cell
    }
}

// MARK: - CollerctionView Delegate
extension CategoryViewController: UICollectionViewDelegate {
}

// MARK: - CollerctionView Flowlayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width
                     - (CGFloat(Padding.leftRightSpacing.rawValue) * 2)
                     - cellSpacing)
                    / 2
        
        let height = width / 1.6
        return CGSize(width: width, height: height)
    }
}
