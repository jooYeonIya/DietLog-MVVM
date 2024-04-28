//
//  MyInfoViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import Foundation
import RxSwift

class MyInfoViewModel {
    
    var nickname: BehaviorSubject<String?> = BehaviorSubject(value: nil)
    var myInfo: BehaviorSubject<MyInfo?> = BehaviorSubject(value: nil)
    
    private let disposeBag = DisposeBag()
    private let manager = UserInfoManager()
    private let myInfoManager = MyInfoManager()
    
    init() {
        nickname.onNext(manager.getNickname())
    }
    
    func getMyInfo(for date: Date) {
        myInfo.onNext(myInfoManager.getMyInfo(for: date))
    }
}
