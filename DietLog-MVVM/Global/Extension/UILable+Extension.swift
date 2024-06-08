//
//  UILable+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

extension UILabel {
    
    func configure(text: String, font: UIFont) {
        self.text = text
        self.font = font
    }
}

class CustomLabel: UILabel {
    init(text: String, font: UIFont) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
