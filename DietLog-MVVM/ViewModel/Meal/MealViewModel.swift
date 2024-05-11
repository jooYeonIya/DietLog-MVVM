//
//  MealViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/30.
//

import RxSwift
import UIKit

class MealViewModel {
    var mealsData: BehaviorSubject<[Meal]> = BehaviorSubject(value: [])
    
    private let disposeBag = DisposeBag()
    private let manager = MealManager.shared
    private let imageManager = ImageFileManager.shared
    
    func findMealsData(byDate date: Date) {
        if let result = manager.loadMealsData(for: date) {
            mealsData.onNext(Array(result))
        }
    }
    
    func findImage(byName imageName: String) -> UIImage? {
        return imageManager.loadImage(with: imageName)
    }
}
