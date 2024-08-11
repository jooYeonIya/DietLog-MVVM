//
//  SignInViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RxCocoa
import RxSwift
import UIKit

protocol SignInViewModelDelegate: AnyObject {
    func moveToMyInfoView()
}

class SignInViewModel {
    var signInResult = PublishSubject<Bool>()
    
    weak var delegate: SignInViewModelDelegate?
    
    private let disposeBag = DisposeBag()
    private let manager = UserInfoManager()
    
    func emptyCheckTextField(_ nickname: String?) {
        signInResult.onNext(nickname != "")
    }
}
