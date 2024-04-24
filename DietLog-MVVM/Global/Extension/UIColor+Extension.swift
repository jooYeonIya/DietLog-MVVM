//
//  UIColor+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

extension UIColor {
    static var customGray: UIColor {
        guard let color = UIColor(named: "customGray") else { return .systemGray6 }
        return color
    }
    
    static var customYellow: UIColor {
        guard let color = UIColor(named: "customYellow") else { return .systemYellow }
        return color
    }
    
    static var customGreen: UIColor {
        guard let color = UIColor(named: "customGreen") else { return .systemGreen }
        return color
    }
}
