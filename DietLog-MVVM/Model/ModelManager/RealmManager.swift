//
//  RealmManager.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RealmSwift

class RealmManager {
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Error RealmManager \(error)")
        }
    }
}

