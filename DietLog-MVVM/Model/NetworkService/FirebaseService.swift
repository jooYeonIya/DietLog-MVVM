//
//  FirebaseService.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 6/9/24.
//

import Foundation
import FirebaseAuth

class FirebaseService {
    static let share = FirebaseService()
    
    func signIn(_ inputData: SignInInputData, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: inputData.email ?? "", password: inputData.password ?? "") { result, error in
            if let error = error {
                completion(false)
                print(error)
                return
            }
            completion(true)
        }
    }
}
