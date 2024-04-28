//
//  CategoryViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

class CategoryViewController: BaseViewController {

    // MARK: - Component
    private lazy var floatingButton = UIButton()
    private lazy var floatingStackView = UIStackView()
    private lazy var grayView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = .systemGray4
        view.isHidden = true
        view.alpha = 0.5

        self.view.insertSubview(view, belowSubview: self.floatingButton)

        return view
    }()
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
    private var isDisplyStackView: Bool = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([categoryCollectionView, floatingButton, floatingStackView])
        
        setupSearchBarUI()
        setupFloatingButtonUI()
        setupStackView()
    }
    
    private func setupSearchBarUI() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupFloatingButtonUI() {
        floatingButton.configureFloatingButton(width: CGFloat(ComponentSize.floatingButton.rawValue))
    }
    
    private func setupStackView() {
        let moveToCategoryEditViewButton = UIButton()
        moveToCategoryEditViewButton.configureFloatingButton(with: "카테고리", and: CGFloat(ComponentSize.floatingButton.rawValue))
        moveToCategoryEditViewButton.titleLabel?.font = .smallBody
        
        let moveToExerciseEditViewButton = UIButton()
        moveToExerciseEditViewButton.configureFloatingButton(with: "운동", and: CGFloat(ComponentSize.floatingButton.rawValue))
        
        floatingStackView.axis = .vertical
        floatingStackView.spacing = 4
        floatingStackView.alignment = .fill
        floatingStackView.distribution = .fillEqually
        floatingStackView.isHidden = true
        floatingStackView.addArrangedSubview(moveToCategoryEditViewButton)
        floatingStackView.addArrangedSubview(moveToExerciseEditViewButton)
    }
    
    // MARK: - Setup Layout
    override func setupLayout() {
        categoryCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalTo(categoryCollectionView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.width.height.equalTo(ComponentSize.floatingButton.rawValue)
        }
        
        floatingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(floatingButton.snp.top).offset(-4)
            make.trailing.equalTo(floatingButton)
            make.width.equalTo(ComponentSize.floatingButton.rawValue)
            make.height.equalTo(ComponentSize.floatingButton.rawValue * 2)
        }
    }
    
    // MARK: - Setup Delegate
    override func setupDelegate() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    // MARK: - Setup Event
    override func setupEvent() {
        floatingButton.addTarget(self, action: #selector(toggleFloatingButton), for: .touchUpInside)
    }
}

// MARK: - 메서드
extension CategoryViewController {
    @objc func toggleFloatingButton() {
    
        if isDisplyStackView {
            UIView.animate(withDuration: 0.3) {
                self.floatingStackView.alpha = 0
                self.grayView.isHidden = true
            }
        } else {
            floatingStackView.isHidden = false
            floatingStackView.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.floatingStackView.alpha = 1
                self.grayView.isHidden = false
            }
        }
        
        isDisplyStackView.toggle()
    }
}

// MARK: - SearchBar
extension CategoryViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
        searchBar.resignFirstResponder()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ExerciseViewController()
        navigationController?.pushViewController(viewController, animated: true)
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
