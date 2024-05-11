//
//  UIButton+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

extension UIButton {
    func configureCircleShape(width: CGFloat) {
        layer.cornerRadius = width / 2
        layer.masksToBounds = true
        
        backgroundColor = .customGreen
    }
    
    func configureFloatingButton(width: CGFloat) {
        configureCircleShape(width: width)
        
        let buttonImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: width / 3, weight: .medium))
        setImage(buttonImage, for: .normal)
        tintColor = .white
    }
    
    func configureFloatingButton(with text: String, and width: CGFloat) {
        configureCircleShape(width: width)
        
        setTitle(text, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .body
    }
}
