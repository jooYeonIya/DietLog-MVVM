//
//  SelectCategoryViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/03.
//

import Foundation
import RxSwift

class SelectCategoryViewModel {
    var categoriesData = BehaviorSubject<[Category]>(value: [])
    var selectedCategory = BehaviorSubject<Category?>(value: nil)
    
    private let manager = CatergoryManager.shared
    
    func getCategorisData() {
        if let result = manager.getAllCategories() {
            categoriesData.onNext(Array(result))
        }
    }
}
