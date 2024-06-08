//
//  KakaoService.swift
//  DietLog-MVVM
//
//  Created by 강주연 on 6/8/24.
//

import Foundation
import KakaoSDKUser



class KakaoService {
    
    static let shared = KakaoService()
    
    func loginWithKakao() {
        
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
        
            // 카카오톡 로그인
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error { 
                    print(error)
                } else {
                    print("로그인 성공!")
                }
            }
        }
    }
}
