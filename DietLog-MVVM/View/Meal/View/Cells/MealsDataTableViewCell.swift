//
//  MealsDataTableViewCell.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

class MealsDataTableViewCell: UITableViewCell {
    
    static let identifier = "MealsDataTableViewCell"
    
    private let mealImageView = UIImageView()
    
    func configure(with image: UIImage?) {

        mealImageView.applyRadius()
        mealImageView.applyShadow()
        mealImageView.applyBorderLine()
        guard let image = image else { return }
        mealImageView.image = image
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.clipsToBounds = true
        
        contentView.backgroundColor = .clear
        contentView.addSubview(mealImageView)
        
        backgroundColor = .clear
        
        mealImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        mealImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
}
