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
    }
}
