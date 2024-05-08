//
//  SelectCategoryTableViewCell.swift
//  ShareDL
//
//  Created by Jooyeon Kang on 2024/05/06.
//

import Foundation
import UIKit

class SelectCategoryTableViewCell: UITableViewCell {
    let label = UILabel()
    
    func configure(with title: String) {
        label.text = title
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont(name: "LINESeedSansKR-Regular", size: 16)
        
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.borderWidth = 1.6
        
        selectionStyle = .none
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.layer.borderColor = UIColor(red: 0.980, green: 0.890, blue: 0.478, alpha: 1.0).cgColor
            contentView.layer.borderWidth = 2.0
        } else {
            contentView.layer.borderColor = UIColor.systemGray4.cgColor
            contentView.layer.borderWidth = 1.6
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }
}
