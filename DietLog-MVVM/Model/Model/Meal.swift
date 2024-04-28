//
//  Meal.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RealmSwift
import UIKit


class Meal: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var postedDate: Date
    @Persisted var imageName: String?
    @Persisted var memo: String?
}
