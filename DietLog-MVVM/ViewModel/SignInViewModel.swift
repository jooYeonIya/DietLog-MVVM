//
//  SignInViewModel.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/28.
//

import RxCocoa
import RxSwift
import UIKit

struct SignInInputData {
    var nickname: String?
    var email: String?
    var password: String?
}

protocol SignInViewModelDelegate: AnyObject {
    func moveToMyInfoView()
}

class SignInViewModel {
    var signInResult = PublishSubject<String>()
    
    weak var delegate: SignInViewModelDelegate?
    
    private let disposeBag = DisposeBag()
    private let manager = UserInfoManager()
    
    func emptyCheckTextFields(_ inputData: SignInInputData) {
        let textFields = [inputData.nickname, inputData.email, inputData.password]
        let isEmptyTextFields = textFields.allSatisfy { text in
            guard let text = text else { return false }
            return !text.isEmpty
        }
        
        if isEmptyTextFields {
            validateCheckTextFields(inputData)
        } else {
            signInResult.onNext(SignInText.emptyCheckError)
        }
    }
    
    private func saveData(_ inputData: SignInInputData) {
        FirebaseService.share.signIn(inputData) { success in
            if success {
                UserInfoManager.shared.createUserInfo(nickname: inputData.nickname ?? "")
                self.delegate?.moveToMyInfoView()
            } else {
                self.signInResult.onNext(SignInText.signInError)
            }
        }
    }
    
    private func validateCheckTextFields(_ inputData: SignInInputData) {
        let isEmailVaild = isEmailVaild(inputData.email ?? "")
        let isPasswordVaild = isPasswordVaild(inputData.password ?? "")
        
        if isEmailVaild && isPasswordVaild {
            saveData(inputData)
        } else if !isEmailVaild {
            signInResult.onNext(SignInText.emailValidateError)
        } else if !isPasswordVaild {
            signInResult.onNext(SignInText.passwordValidateError)
        }
    }
    
    private func isEmailVaild(_ email: String) -> Bool {
        do {
            // 알파벳과 숫자 중간에 @가 포함되며 끝 2-3자리 앞에 . 이 포함
            let emailPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
            let emailExpression = try NSRegularExpression(pattern: emailPattern)
            return emailExpression.firstMatch(in: email, range: NSRange(location: 0, length: email.count)) != nil
        } catch {
            return false
        }
    }
    
    private func isPasswordVaild(_ password: String) -> Bool {
        do {
            // 8-16자리 영어, 숫자 포함
            let passwordPattern = "^[0-9a-z]{8,16}$"
            let passwordExpression = try NSRegularExpression(pattern: passwordPattern)
            return passwordExpression.firstMatch(in: password, range: NSRange(location: 0, length: password.count)) != nil
        } catch {
            return false
        }
    }
}
