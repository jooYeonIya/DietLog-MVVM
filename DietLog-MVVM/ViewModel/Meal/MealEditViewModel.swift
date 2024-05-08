//
//  MealEditViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/30.
//

import RxSwift
import UIKit
import RealmSwift

class MealEditViewModel {
    var memoTextView = BehaviorSubject<NSAttributedString?>(value: nil)
    var mealData: BehaviorSubject<Meal?> = BehaviorSubject(value: nil)
    
    private var memoText: NSAttributedString?
    
    private let disposeBag = DisposeBag()
    private let manager = MealManager.shared
    private let imageManager = ImageFileManager.shared

    init() {
        memoTextView
            .subscribe { [weak self] memoText in
                self?.memoText = memoText
            }
            .disposed(by: disposeBag)
    }
    
    func saveMealData(by date: Date, withImage image: UIImage?) -> Bool {

        if memoText?.string == "" && image == nil {
            return false
        }
        
        let mealData = Meal()
        mealData.postedDate = date
        mealData.memo = memoText?.string
        
        if let image = image {
            let imageName = UUID().uuidString
            imageManager.saveImage(imageName: "\(imageName).png", image: image)
            mealData.imageName = imageName
        } else {
            mealData.imageName = nil
        }
        
        manager.create(mealData)
        
        return true
    }
    
    func findMealData(by id: ObjectId) {
        if let result = manager.loadMealData(for: id) {
            mealData.onNext(result)
        }
    }
    
    func remove(_ mealData: Meal) {
        if let imageName = mealData.imageName {
            imageManager.removeImage(with: imageName)
        }
        
        manager.delete(mealData)
    }
    
    func modify(_ oldMealData: Meal, withDate date: Date, memo: String?, image: UIImage?) {
        
        let newMealData = Meal()
        newMealData.postedDate = date
        newMealData.memo = memo
        
        if let selectedImage = image {
            if let imageName = oldMealData.imageName {
                imageManager.removeImage(with: imageName)
            }
            
            let imageName = UUID().uuidString
            imageManager.saveImage(imageName: "\(imageName).png", image: selectedImage)
            
            newMealData.imageName = imageName
        } else {
            newMealData.imageName = nil
        }
    
        manager.update(oldMealData, newMealData: newMealData)
    }
    
    func findImage(byName imageName: String?) -> UIImage? {
        if let imageName = imageName {
            let image = imageManager.loadImage(with: imageName)
            return image
        } else {
            return UIImage(named: "MealBasicImage")
        }
    }
}
