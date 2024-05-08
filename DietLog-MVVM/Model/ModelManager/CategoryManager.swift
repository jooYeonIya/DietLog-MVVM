//
//  CategoryManager.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import Foundation
import RealmSwift

class CatergoryManager: RealmManager {
    
    static let shared = CatergoryManager()
    
    func addCategory(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error func addExerciseCategory \(error)")
        }
    }

    func getAllCategories() -> Results<Category>? {
        return realm.objects(Category.self)
    }
    
    func getCategory(at id: ObjectId) -> Category? {
        let query = NSPredicate(format: "id == %@", id)
        return realm.objects(Category.self).filter(query).first
    }

    func updateCategory(_ category: Category, newTitle: String){
        do {
            try realm.write {
                category.title = newTitle
            }
        } catch {
            print("Error func updateExerciseCategory \(error)")
        }
    }

    func deleteCategory(_ category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error func deleteExerciseCategory \(error)")
        }
    }
}

