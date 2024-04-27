//
//  UISegmentControl+Extension.swift
//  DietLog-MVVM
//
//  Created by 강주연 on 4/27/24.
//

import UIKit

extension UISegmentedControl {
    func setBackgroundWhiteImage() {
        let image = UIImage()
        
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    }
}
