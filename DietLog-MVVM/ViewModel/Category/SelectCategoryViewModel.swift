//
//  SelectCategoryViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/03.
//

import Foundation
import RxSwift
import RealmSwift

class SelectCategoryViewModel {
    var categoriesData = BehaviorSubject<[Category]>(value: [])
    var selectedCategory = BehaviorSubject<Category?>(value: nil)
    
    private let manager = CatergoryManager.shared
    
    func getCategorisData() {
        if let result = manager.loadAllCategories() {
            categoriesData.onNext(Array(result))
        }
    }
    
    func getCategoryData(at id: ObjectId) {
        selectedCategory.onNext(manager.loadCategory(at: id))
    }
}
