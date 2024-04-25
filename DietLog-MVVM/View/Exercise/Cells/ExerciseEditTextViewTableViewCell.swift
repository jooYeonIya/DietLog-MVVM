//
//  ExerciseTextViewTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

enum ExerciseEditTableViewCellText: String {
    case ULR = "URL"
    case category = "카테고리"
    case memo = "메모"
}

class ExerciseEditTableViewCell: UITableViewCell {
    
    static let indetifier = "ExerciseEditTableViewCell"
    
    func configure() {
        let titleLabel = UILabel()
        titleLabel.configure(text: ExerciseEditTableViewCellText.category.rawValue , font: .body)
        
        let label = UILabel()
        label.configure(text: "미선택", font: .body)
        
        contentView.addSubviews([titleLabel, label])
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
                                 
        label.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-Padding.leftRightSpacing.rawValue)
        }
    }
}
