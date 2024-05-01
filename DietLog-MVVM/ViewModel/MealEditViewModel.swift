//
//  MealEditViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/30.
//

import Foundation
import RxSwift
import UIKit
import RealmSwift

class MealEditViewModel {
    var memoTextView = BehaviorSubject<NSAttributedString?>(value: nil)
    var mealData: BehaviorSubject<Meal?> = BehaviorSubject(value: nil)
    
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
        
        let meal = Meal()
        meal.postedDate = date
        meal.memo = memoText?.string
        
        if let image = image {
            let imageName = UUID().uuidString
            ImageFileManager.shared.saveImage(imageName: "\(imageName).png", image: image)
            meal.imageName = imageName
        } else {
            meal.imageName = nil
        }
        
        manager.addMeal(meal)
        return true
    }
    
    func getMealData(with id: ObjectId) {
        if let result = manager.getMeal(for: id) {
            mealData.onNext(result)
        }
    }
    
    func deleteMealData(_ mealData: Meal) {
        if let imageName = mealData.imageName {
            ImageFileManager.shared.removeImage(with: imageName)
        }
        
        manager.deleteMeal(mealData)
    }
    
    func modifyMealData(_ mealData: Meal,
                        selectedDate: Date,
                        memo: String?,
                        selectedImage: UIImage?) {
        
        let newMeal = Meal()
        newMeal.postedDate = selectedDate
        newMeal.memo = memo
        
        if let selectedImage = selectedImage {
            if let imageName = mealData.imageName {
                ImageFileManager.shared.removeImage(with: imageName)
            }
            
            let imageName = UUID().uuidString
            ImageFileManager.shared.saveImage(imageName: "\(imageName).png", image: selectedImage)
            
            newMeal.imageName = imageName
        } else {
            newMeal.imageName = nil
        }
    
        manager.updateMeal(mealData, newMeal: newMeal)
    }
    
    func loadImage(with imageName: String?) -> UIImage? {
        if let imageName = imageName {
            let image = ImageFileManager.shared.loadImage(with: imageName)
            return image
        } else {
            return UIImage(named: "MealBasicImage")
        }
    }
}
