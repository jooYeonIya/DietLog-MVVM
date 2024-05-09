//
//  MyInfoManager.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import Foundation
import RealmSwift

class MyInfoManager: RealmManager {
    
    static let shared = MyInfoManager()

    func create(_ myInfo: MyInfo) {
        do {
            try realm.write{
                realm.add(myInfo)
            }
        } catch {
            print("Error func addMyInfo \(error)")
        }
    }
    
    func loadAllMyInfo() -> Results<MyInfo>? {
        return realm.objects(MyInfo.self)
    }
    
    func loadMyInfo(for date: Date) -> MyInfo? {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        
        let myInfo = realm.objects(MyInfo.self).filter("postedDate >= %@ AND postedDate < %@", startDate, endDate)
        return myInfo.first
    }


    func update(_ oldMyInfo: MyInfo, newInfo: MyInfo) {
        do {
            try realm.write {
                oldMyInfo.weight = newInfo.weight
                oldMyInfo.muscle = newInfo.muscle
                oldMyInfo.fat = newInfo.fat
            }
        } catch {
            print("Error func updateMyInfo \(error)")
        }
    }

    func delete(_ myInfo: MyInfo) {
        do {
            try realm.write {
                realm.delete(myInfo)
            }
        } catch {
            print("Error func deleteMyInfo \(error)")
        }
    }
}

