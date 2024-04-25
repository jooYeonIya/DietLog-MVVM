//
//  ExerciseEditWithTextFieldTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

class ExerciseEditTextFieldTableViewCell: UITableViewCell {

    static let indetifier = "ExerciseEditWithTextFieldTableViewCell"
    
    func configure() {
        let label = UILabel()
        label.configure(text: ExerciseEditTableViewCellText.ULR.rawValue , font: .body)
        
        let textField = UITextField()
        textField.configure()
        
        contentView.addSubviews([label, textField])
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Padding.leftRightSpacing.rawValue)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(12)
            make.leading.trailing.equalTo(label)
            make.height.equalTo(ComponentSize.textFieldHeight.rawValue)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
