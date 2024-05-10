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
    
    func create(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error func addExerciseCategory \(error)")
        }
    }

    func loadAllCategories() -> Results<Category>? {
        return realm.objects(Category.self)
    }
    
    func loadCategory(at id: ObjectId) -> Category? {
        let query = NSPredicate(format: "id == %@", id)
        return realm.objects(Category.self).filter(query).first
    }

    func update(_ oldCategory: Category, newTitle: String){
        do {
            try realm.write {
                oldCategory.title = newTitle
            }
        } catch {
            print("Error func updateExerciseCategory \(error)")
        }
    }

    func delete(_ category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error func deleteExerciseCategory \(error)")
        }
    }
}

