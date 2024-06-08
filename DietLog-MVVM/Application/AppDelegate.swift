//
//  AppDelegate.swift
//  DietLog-MVVM
//
//  Created by Jooyeon Kang on 2024/04/23.
//

import UIKit
import IQKeyboardManagerSwift
import KakaoSDKCommon
import NaverThirdPartyLogin


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        let nativeKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String
        KakaoSDK.initSDK(appKey: nativeKey ?? "")
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isInAppOauthEnable = true
        instance?.serviceUrlScheme = "com.studyiOS.DietLog"
        instance?.consumerKey = Bundle.main.object(forInfoDictionaryKey: "NAVER_CONSUMER_KEY") as? String
        instance?.consumerSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_CONSUMER_SECRET") as? String
        instance?.appName = "DietLog"
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

