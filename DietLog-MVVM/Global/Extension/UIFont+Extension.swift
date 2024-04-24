//
//  UIFont+Extension.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/24.
//

import UIKit

struct FontName {
    static let bold = "LINESeedSansKR-Bold"
    static let regular = "LINESeedSansKR-Regular"
}

extension UIFont {
    static var largeTitle: UIFont {
        guard let font = UIFont(name: FontName.bold, size: 24) else { return boldSystemFont(ofSize: 24) }
        return font
    }
    
    static var title: UIFont {
        guard let font = UIFont(name: FontName.bold, size: 20) else { return .boldSystemFont(ofSize: 20) }
        return font
    }
    
    static var body: UIFont {
        guard let font = UIFont(name: FontName.regular, size: 16) else { return systemFont(ofSize: 16) }
        return font
    }
    
    static var smallBody: UIFont {
        guard let font = UIFont(name: FontName.regular, size: 12) else { return .systemFont(ofSize: 12) }
        return font
    }
}
