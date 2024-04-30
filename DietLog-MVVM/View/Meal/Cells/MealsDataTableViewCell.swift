//
//  MealsDataTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

class MealsDataTableViewCell: UITableViewCell {
    
    static let identifier = "MealsDataTableViewCell"
    
    func configure(with image: UIImage?) {
        let imageView = UIImageView()
        imageView.applyRadius()
        imageView.applyShadow()
        imageView.applyBorderLine()
        guard let image = image else { return }
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        contentView.backgroundColor = .customGray
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
