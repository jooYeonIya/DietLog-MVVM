//
//  ExerciseSelectCategoryTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/26.
//

import UIKit

class ExerciseSelectCategoryTableViewCell: UITableViewCell {

    static let identifier = "ExerciseSelectCategoryTableViewCell"
    
    func configure(with section: Int) {
        let label = UILabel()
        label.configure(text: "Exasfa", font: .body)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        
        let view = UIView()
        view.backgroundColor = section % 2 == 0 ? .customYellow : .customGreen
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
}
