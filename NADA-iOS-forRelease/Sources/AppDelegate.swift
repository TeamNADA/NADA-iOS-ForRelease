//
//  AppDelegate.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/08/08.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var isLogin = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        KakaoSDKCommon.initSDK(appKey: "5b8dd8cc878344bb7532eeca4365a4aa")
        let acToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken)
        
        if acToken != nil {
            if UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.isAppleLogin) {
                // 애플 로그인으로 연동되어 있을 때, -> 애플 ID와의 연동상태 확인 로직
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: Const.UserDefaultsKey.userID) { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        print("해당 ID는 연동되어있습니다.")
                        self.isLogin = true
                    case .revoked:
                        print("해당 ID는 연동되어있지않습니다.")
                        self.isLogin = false
                    case .notFound:
                        print("해당 ID를 찾을 수 없습니다.")
                        self.isLogin = false
                    default:
                        break
                    }
                }
            } else {
                if AuthApi.hasToken() {     // 유효한 토큰 존재
                    UserApi.shared.accessTokenInfo { (_, error) in
                        if let error = error {
                            if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                                self.isLogin = false
                            }
                        } else {
                            // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                            self.isLogin = true
                        }
                    }
                } else {
                    // 카카오 토큰 없음 -> 로그인 필요
                    self.isLogin = false
                }
            }
        } else {
            self.isLogin = false    // acToken 값이 nil일 때 -> 로그인 뷰로
        }

        // 앱 실행 중 애플 ID 강제로 연결 취소 시
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
            print("Revoked Notification")
            self.isLogin = false
        }
        
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

extension UserDefaults {
    public static func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: Const.UserDefaultsKey.hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
