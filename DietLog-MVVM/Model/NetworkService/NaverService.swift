//
//  NaverService.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 6/9/24.
//

import Foundation
import NaverThirdPartyLogin

class NaverService {
    static let share = NaverService()
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func loginWithNaver() {
        loginInstance?.requestThirdPartyLogin()
    }
}
