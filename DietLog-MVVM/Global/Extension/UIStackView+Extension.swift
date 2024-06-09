//
//  UIStackView+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 6/9/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}
