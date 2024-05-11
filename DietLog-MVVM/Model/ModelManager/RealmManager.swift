//
//  RealmManager.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RealmSwift
import Foundation

class RealmManager {
    var realm: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.studyiOS.DietLog")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        do {
            return try Realm(configuration: config)
        } catch {
            fatalError("Error RealmManager \(error)")
        }
    }
}

