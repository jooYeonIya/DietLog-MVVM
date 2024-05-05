//
//  RecentSearchView.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/05.
//

import UIKit

class RecentSearchView: UIView {
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
    
    // MARK: - 변수
    var recentWords: [String] = ["최근", "검색어", "최근 검색어"]
    
    private lazy var recentWordLabel = UILabel()
    private lazy var recentWordAllDeleteButton = UIButton()
    
    func configure() {
        addSubviews([recentWordLabel,
                     recentWordCollectionView,
                     recentWordAllDeleteButton])
        
        setupUI()
        setupLayout()
        setupDelegate()
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
    
    private func setupDelegate() {
        recentWordCollectionView.dataSource = self
        recentWordCollectionView.delegate = self
    }
}

// MARK: - CollectionView
extension RecentSearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
