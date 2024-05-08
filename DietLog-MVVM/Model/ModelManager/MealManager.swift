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
    
    func create(_ meal: Meal) {
        do {
            try realm.write {
                realm.add(meal)
            }
        } catch {
            print("Error func addMeal \(error)")
        }
    }

    func loadAllMealsData() -> Results<Meal>? {
        return realm.objects(Meal.self)
    }
    
    func loadMealsData(for date: Date) -> Results<Meal>? {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        
        let meals = realm.objects(Meal.self).filter("postedDate >= %@ AND postedDate < %@", startDate, endDate)
        return meals
    }
    
    func loadMealData(for id: ObjectId) -> Meal? {
        let query = NSPredicate(format: "id == %@", id)
        return realm.objects(Meal.self).filter(query).first
    }

    func update(_ oldMealData: Meal, newMealData: Meal){
        do {
            try realm.write {
                oldMealData.postedDate = newMealData.postedDate
                oldMealData.imageName = newMealData.imageName
                oldMealData.memo = newMealData.memo
            }
        } catch {
            print("Error func updateMeal \(error)")
        }
    }

    func delete(_ mealData: Meal) {
        do {
            try realm.write {
                realm.delete(mealData)
            }
        } catch {
            print("Error func deleteMeal \(error)")
        }
    }
}

