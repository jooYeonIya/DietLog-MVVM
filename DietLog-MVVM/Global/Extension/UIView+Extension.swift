//
//  UIView+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
    
    func applyShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
    }
    
    func applyRadius() {
        layer.cornerRadius = 16
    }
}
