//
//  CategoryViewController.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit
import RxSwift

class CategoryViewController: BaseViewController {

    // MARK: - Component
    private lazy var noDataLabel = UILabel()
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
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - 변수
    private let cellSpacing: CGFloat = 12
    private var categoriesData: [Category] = []
    private var isDisplyStackView: Bool = false
    private var viewModel = CategoryViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTopView(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Setup UI
    override func setupUI() {
        view.addSubviews([noDataLabel, categoryCollectionView, floatingButton, floatingStackView])
        
        setupNoDataLabelUI()
        setupSearchBarUI()
        setupFloatingButtonUI()
        setupStackView()
    }
    
    private func setupNoDataLabelUI() {
        noDataLabel.configure(text: LocalizedText.plusData, font: .body)
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
        moveToCategoryEditViewButton.addTarget(self, action: #selector(moveToCategoryEditView), for: .touchUpInside)
        
        let moveToExerciseEditViewButton = UIButton()
        moveToExerciseEditViewButton.configureFloatingButton(with: "운동", and: CGFloat(ComponentSize.floatingButton.rawValue))
        moveToExerciseEditViewButton.addTarget(self, action: #selector(moveToExerciseEditView), for: .touchUpInside)

        
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
        noDataLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFloatingButton))
        grayView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Setup Bind
    override func setupBinding() {
        viewModel.categoriesData
            .subscribe { [weak self] result in
                self?.categoriesData = result
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 메서드
extension CategoryViewController {
    private func reloadData() {
        viewModel.getCategories()
        categoryCollectionView.reloadData()
        
        let hasData = !categoriesData.isEmpty
        categoryCollectionView.isHidden = !hasData
        noDataLabel.isHidden = hasData
    }
    
    @objc func toggleFloatingButton() {
        
        if isDisplyStackView {
            UIView.animate(withDuration: 0.3) {
                self.floatingStackView.alpha = 0
                self.grayView.isHidden = true
                self.floatingButton.transform = CGAffineTransform.identity
            }
        } else {
            floatingStackView.isHidden = false
            floatingStackView.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.floatingStackView.alpha = 1
                self.grayView.isHidden = false
                self.floatingButton.transform = CGAffineTransform(rotationAngle: .pi - (.pi / 4))
            }
        }
        
        isDisplyStackView.toggle()
    }
    
    @objc func moveToCategoryEditView() {
        let viewController = CategoryEditViewController()
        navigationController?.pushViewController(viewController, animated: true)
        toggleFloatingButton()
    }
    
    @objc func moveToExerciseEditView() {
        let viewController = ExerciseCreateEditViewController()
        navigationController?.pushViewController(viewController, animated: true)
        toggleFloatingButton()
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
extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: categoriesData[indexPath.row].title)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ExerciseViewController(categoryId: categoriesData[indexPath.row].id)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - CollerctionView Flowlayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width
                     - (CGFloat(Padding.leftRightSpacing.rawValue) * 2)
                     - cellSpacing)
                    / 2
        
        return CGSize(width: width, height: width)
    }
}

// MAKR: - 수정 삭제
extension CategoryViewController: CategoryCollectionViewCellDelegate {

    func didTappedOptionButton(_ cell: CategoryCollectionViewCell) {
        guard let indexPath = categoryCollectionView.indexPath(for: cell) else { return }
        let category = categoriesData[indexPath.row]
        
        showOptionMenuSheet {
            self.moveToModifyView(category)
        } deleteCompletion: {
            self.deleteCategory(category)
        }

    }
    
    private func moveToModifyView(_ category: Category) {
        let viewController = CategoryEditViewController(category: category)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func deleteCategory(_ category: Category) {
        viewModel.deleteCategory(category)
        
        showAlertWithOKButton(title: "", message: "삭제했습니다") {
            self.navigationController?.popViewController(animated: true)
            self.reloadData()
        }
    }
}
