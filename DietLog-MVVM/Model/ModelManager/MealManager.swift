//
//  MealManager.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RealmSwift
import Foundation

class MealManager: RealmManager {
    
    static let shared = MealManager()
    
    func addMeal(_ meal: Meal) {
        do {
            try realm.write {
                realm.add(meal)
            }
        } catch {
            print("Error func addMeal \(error)")
        }
    }

    func getAllMeals() -> Results<Meal>? {
        return realm.objects(Meal.self)
    }
    
    func getMeal(for id: ObjectId) -> Meal? {
        let query = NSPredicate(format: "id == %@", id)
        return realm.objects(Meal.self).filter(query).first
    }
    
    func getMeals(for date: Date) -> Results<Meal>? {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        
        let meals = realm.objects(Meal.self).filter("postedDate >= %@ AND postedDate < %@", startDate, endDate)
        return meals
    }

    func updateMeal(_ meal: Meal, newMeal: Meal){
        do {
            try realm.write {
                meal.postedDate = newMeal.postedDate
                meal.imageName = newMeal.imageName
                meal.memo = newMeal.memo
            }
        } catch {
            print("Error func updateMeal \(error)")
        }
    }

    func deleteMeal(_ meal: Meal) {
        do {
            try realm.write {
                realm.delete(meal)
            }
        } catch {
            print("Error func deleteMeal \(error)")
        }
    }
}

