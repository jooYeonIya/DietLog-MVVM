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

    private let disposeBag = DisposeBag()
    private let manager = UserInfoManager()
    
    init() {
        nickname.onNext(manager.getNickname())
    }
}
