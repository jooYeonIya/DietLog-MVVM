//
//  CategoryCollectionViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    var view = UIView()
    var label = UILabel()
    var button = UIButton()
    
    func configure(with text: String) {
        view.applyRadius()
        view.applyShadow()
        view.backgroundColor = .customYellow
        
        label.configure(text: text, font: .title)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        
        button.setImage(UIImage(named: "OptionMenu"), for: .normal)
        
        view.addSubviews([label, button])
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalTo(button.snp.bottom)
            make.width.equalToSuperview().inset(12)
        }
        
        button.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(20)
        }
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
