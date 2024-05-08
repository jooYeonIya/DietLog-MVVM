//
//  RecentWordCollectionViewCell.swift
//  DietLog-MVVM
//
//  Created by 강주연 on 4/27/24.
//

import UIKit

protocol RecentWordCollectionViewCellDelegate: AnyObject {
    func didTappedDeleteButton(_ cell: RecentWordCollectionViewCell)
}

class RecentWordCollectionViewCell: UICollectionViewCell {
    
    static let identified = "RecentWordCollectionViewCell"
    
    weak var delegate: RecentWordCollectionViewCellDelegate?
    
    let label = UILabel()
    let button = UIButton()
    
    func configure(text: String) {
        label.configure(text: text, font: .smallBody)
        label.textColor = .customGreen
        
        let buttonImage = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10))
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .customGreen
        button.addTarget(self, action: #selector(didTappedDelegateButton), for: .touchUpInside)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.customGreen.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.addSubviews([label, button])
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.lessThanOrEqualTo(label.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func didTappedDelegateButton() {
        delegate?.didTappedDeleteButton(self)
    }
}
