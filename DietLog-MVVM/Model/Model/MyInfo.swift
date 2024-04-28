//
//  MyInfo.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RealmSwift
import UIKit

class MyInfo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var postedDate: Date
    @Persisted var weight: String?
    @Persisted var muscle: String?
    @Persisted var fat: String?
}

