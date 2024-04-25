//
//  CategoryCollectionViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    func configure(with text: String) {
        let view = UIView()
        view.applyRadius()
        view.applyShadow()
        view.backgroundColor = .customYellow
        
        let label = UILabel()
        label.configure(text: text, font: .title)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        
        view.addSubviews([label, button])
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalTo(button.snp.bottom)
            make.width.equalToSuperview().inset(12)
        }
        
        button.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(20)
        }
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
