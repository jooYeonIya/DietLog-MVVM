//
//  UserInfoManager.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import Foundation

enum UserInfoKeys {
    static let isCompletedFirstFaunch = "isCompletedFirstFaunch"
    static let nickName = "nickName"
}


class UserInfoManager {
    static let shared = UserInfoManager()
    let userDefaults = UserDefaults.standard
    
    func addUserInfo(nickname: String) {
        userDefaults.setValue(nickname, forKey: UserInfoKeys.nickName)
        userDefaults.setValue(true, forKey: UserInfoKeys.isCompletedFirstFaunch)
    }
    
    func getIsCompletedFirstFaunch() -> Bool {
        return userDefaults.bool(forKey: UserInfoKeys.isCompletedFirstFaunch)
    }
}
