//
//  RecentSearchView.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import UIKit
import RxSwift

class RecentSearchView: UIView {
    // MARK: - Component
    lazy var recentWordCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(RecentWordCollectionViewCell.self, forCellWithReuseIdentifier: RecentWordCollectionViewCell.identified)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var recentWordLabel = UILabel()
    private lazy var recentWordAllDeleteButton = UIButton()
    
    // MARK: - 변수
    var recentSearchWords: [String] = []
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    func configure() {
        addSubviews([recentWordLabel,
                     recentWordCollectionView,
                     recentWordAllDeleteButton])
        
        reloadData()
        setupUI()
        setupLayout()
        setupEvent()
        setupBinding()
    }

    private func setupUI() {
        recentWordLabel.configure(text: SearchViewText.recentWord.rawValue, font: .title)
        recentWordLabel.textColor = .black
        
        recentWordAllDeleteButton.setTitle("전체 삭제", for: .normal)
        recentWordAllDeleteButton.setTitleColor(.systemGray, for: .normal)
        recentWordAllDeleteButton.titleLabel?.font = .smallBody
    }
    
    private func setupLayout() {
        recentWordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(recentWordAllDeleteButton.snp.leading)
        }
        
        recentWordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentWordLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalTo(recentWordAllDeleteButton)
            make.height.equalTo(24)
        }
        
        recentWordAllDeleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentWordLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupEvent() {
        recentWordAllDeleteButton.addTarget(self, action: #selector(didTappedAllRecentSearchWordsButton), for: .touchUpInside)
    }
    
    private func setupBinding() {
        viewModel.recentSearchWords
            .subscribe { [weak self] result in
                self?.recentSearchWords = result
                self?.recentWordCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        recentWordCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.recentSearchWords
            .bind(to: recentWordCollectionView.rx.items(cellIdentifier: RecentWordCollectionViewCell.identified, cellType: RecentWordCollectionViewCell.self)) { index, model, cell in
                
                cell.configure(text: model)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
    }
    
    func reloadData() {
        viewModel.getRecentSearchWords()
    }
    
    @objc func didTappedAllRecentSearchWordsButton() {
        viewModel.searchBar.onNext(true)
        viewModel.deleteAllRecenteSearchWords()
        reloadData()
    }
}

// MARK: - CollectionView
extension RecentSearchView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = recentSearchWords[indexPath.row]
        let textAttributes = [NSAttributedString.Key.font: UIFont.smallBody]
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width
        
        let delegateButtonWidth: CGFloat = 20
        let spacing: CGFloat = (8 * 2) + 4
        
        let width = textWidth + delegateButtonWidth + spacing
        
        return CGSize(width: width, height: 20)
    }
}

extension RecentSearchView: RecentWordCollectionViewCellDelegate {
    func didTappedDeleteButton(_ cell: RecentWordCollectionViewCell) {
        guard let indexPath = recentWordCollectionView.indexPath(for: cell) else { return }
        viewModel.deleteRecenteSearchWord(at: indexPath.row)
        viewModel.searchBar.onNext(true)
        reloadData()
    }
}
