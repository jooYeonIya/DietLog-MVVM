//
//  MealViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/30.
//

import Foundation
import RxSwift
import UIKit

class MealViewModel {
    var mealsData: BehaviorSubject<[Meal]?> = BehaviorSubject(value: nil)
    
    private let disposeBag = DisposeBag()
    private let manager = MealManager.shared
    private let imageManager = ImageFileManager.shared
    
    func getMealsData(for date: Date) {
        if let result = manager.getMeals(for: date) {
            mealsData.onNext(Array(result))
        }
    }
    
    func getImgae(with imageName: String) -> UIImage? {
        return imageManager.loadImage(with: imageName)
    }
}
