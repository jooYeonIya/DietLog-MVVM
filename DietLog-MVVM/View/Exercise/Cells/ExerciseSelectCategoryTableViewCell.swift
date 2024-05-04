//
//  ExerciseSelectCategoryTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/26.
//

import UIKit

class ExerciseSelectCategoryTableViewCell: UITableViewCell {

    static let identifier = "ExerciseSelectCategoryTableViewCell"
    
    let label = UILabel()
    let view = UIView()
    
    func configure(with title: String) {

        label.configure(text: title, font: .body)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
    
        view.backgroundColor = .customYellow
        view.applyRadius()
        view.applyShadow()
        
        contentView.backgroundColor = .customGray
        contentView.addSubviews([view, label])
        
        label.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalTo(view)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
