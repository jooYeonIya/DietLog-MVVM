//
//  MealEditViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/30.
//

import Foundation
import RxSwift
import UIKit

class MealEditViewModel {
    var memoTextView = BehaviorSubject<NSAttributedString?>(value: nil)
    
    private var memoText: NSAttributedString?
    
    private let disposeBag = DisposeBag()
    private let manager = MealManager.shared
    
    init() {
        memoTextView
            .subscribe { [weak self] memoText in
                self?.memoText = memoText
            }
            .disposed(by: disposeBag)
    }
    
    func saveMeal(for date: Date, and image: UIImage?) -> Bool {

        if memoText?.string == "" && image == nil {
            return false
        }
        
        let selectedImage = image ?? UIImage(named: "MealBasicImage")!
        let imageName = UUID().uuidString
        ImageFileManager.shared.saveImage(imageName: "\(imageName).png", image: selectedImage)

        let meal = Meal()
        meal.postedDate = date
        meal.memo = memoText?.string
        meal.imageName = imageName
        manager.addMeal(meal)
        return true
    }
}
