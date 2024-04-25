//
//  TabBarOption.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/25.
//

import UIKit

enum TabBarOption: Int, CaseIterable {
    case meal, myInfo, exercise
    
    func toTabTitle() -> String {
        switch self {
        case .meal: return "식단"
        case .myInfo: return "내 정보"
        case .exercise: return "운동"
        }
    }
    
    func toTabImage() -> UIImage {
        switch self {
        case .meal: return UIImage(named: "Meal") ?? UIImage()
        case .myInfo: return UIImage(named: "MyInfo") ?? UIImage()
        case .exercise: return UIImage(named: "Exercise") ?? UIImage()
        }
    }
}
