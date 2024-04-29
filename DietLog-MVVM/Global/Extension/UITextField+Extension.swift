//
//  UITextField+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

extension UITextField {
    func configure(width: CGFloat = CGFloat(ComponentSize.textFieldHeight.rawValue)) {
        font = .body
        
        layer.cornerRadius = width / 2
        layer.masksToBounds = true
        
        layer.borderColor = UIColor.customYellow.cgColor
        layer.borderWidth = 1.2
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
        leftView = leftPaddingView
        leftViewMode = .always
    }
}
