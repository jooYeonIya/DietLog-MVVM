//
//  ExerciseEditTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

class ExerciseEditTextViewTableViewCell: UITableViewCell {
    
    static let indetifier = "ExerciseEditTextViewTableViewCell"
    
    func configure() {
        let label = UILabel()
        label.configure(text: ExerciseEditTableViewCellText.memo.rawValue , font: .body)
    
        let textView = UITextView()
        textView.applyRadius()
        textView.layer.borderColor = UIColor.customYellow.cgColor
        textView.layer.borderWidth = 1.2
        
        contentView.addSubviews([label, textView])
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
                                 
        textView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.leading.trailing.equalTo(label)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(200)
        }
    }
}
