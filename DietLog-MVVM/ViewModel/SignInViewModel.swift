//
//  SignInViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RxCocoa
import RxSwift
import UIKit

class SignInViewModel {
    let nickname = PublishSubject<String?>()
    let signInResult = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    private let manager = UserInfoManager()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
         nickname
            .map { nickname in
                guard let nickname = nickname, !nickname.isEmpty else {
                    return false
                }
                
                self.manager.addUserInfo(nickname: nickname)
                return true
            }
            .bind(to: signInResult)
            .disposed(by: disposeBag)
    }
}
