//
//  CategoryCollectionViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

protocol CategoryCollectionViewCellDelegate: AnyObject {
    func didTappedOptionButton(_ cell: CategoryCollectionViewCell)
}

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    weak var delegate: CategoryCollectionViewCellDelegate?
    
    var view = UIView()
    var label = UILabel()
    var button = UIButton()
    
    func configure(with text: String) {
        view.applyRadius()
        view.applyShadow()
        view.backgroundColor = .customYellow
        
        label.configure(text: text, font: .boldBody)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        
        button.setImage(UIImage(named: "OptionMenu"), for: .normal)
        button.addTarget(self, action: #selector(didTappedOptionButton), for: .touchUpInside)
        
        view.addSubviews([label, button])
        
        label.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(button.snp.bottom).offset(2)
            make.bottom.leading.trailing.equalToSuperview().inset(8)
            make.centerYWithinMargins.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(20)
        }
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func didTappedOptionButton() {
        delegate?.didTappedOptionButton(self)
    }
}
