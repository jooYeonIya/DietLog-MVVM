//
//  CategoryViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/05/01.
//

import Foundation
import RxSwift

class CategoryViewModel {
    var categoryNameTextField: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    var categoriesData: BehaviorSubject<[Category]> = BehaviorSubject(value: [])
    
    private var manager = CatergoryManager.shared
    private var categoryName: String?
    private var disposeBag = DisposeBag()
    
    init() {
        categoryNameTextField
            .subscribe { name in
                self.categoryName = name
            }
            .disposed(by: disposeBag)
    }
    
    func saveCategory() -> Bool {
        if categoryName == "" {
            return false
        }
        
        let category = Category()
        category.title = categoryName ?? "카테고리"
        manager.create(category)
        
        return true
    }
    
    func findCategories(){
        if let result = manager.loadAllCategories() {
            categoriesData.onNext(Array(result))
        }
    }
    
    func remove(_ category: Category) {
        manager.delete(category)
    }
    
    func modify(_ category: Category) -> Bool {
        if categoryName == "" {
            return false
        }
        
        manager.update(category, newTitle: categoryName ?? "카테고리")
        
        return true
    }
}
