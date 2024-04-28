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

    func addMyInfo(_ info: MyInfo) {
        do {
            try realm.write{
                realm.add(info)
            }
        } catch {
            print("Error func addMyInfo \(error)")
        }
    }
    
    func getAllMyInfo() -> Results<MyInfo>? {
        return realm.objects(MyInfo.self)
    }
    
    func getMyInfo(for date: Date) -> MyInfo? {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        
        let myInfo = realm.objects(MyInfo.self).filter("postedDate >= %@ AND postedDate < %@", startDate, endDate)
        return myInfo.first
    }


    func updateMyInfo(_ info: MyInfo, newInfo: MyInfo) {
        do {
            try realm.write {
                info.weight = newInfo.weight
                info.muscle = newInfo.muscle
                info.fat = newInfo.fat
            }
        } catch {
            print("Error func updateMyInfo \(error)")
        }
    }

    func deleteMyInfo(_ info: MyInfo) {
        do {
            try realm.write {
                realm.delete(info)
            }
        } catch {
            print("Error func deleteMyInfo \(error)")
        }
    }
}

