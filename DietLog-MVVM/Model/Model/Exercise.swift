//
//  Exercise.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RealmSwift

class Exercise: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var URL: String
    @Persisted var thumbnailURL: String
    @Persisted var memo: String?
    @Persisted var categoryID: ObjectId
}
