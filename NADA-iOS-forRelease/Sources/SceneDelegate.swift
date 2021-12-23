//
//  SceneDelegate.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/08/08.
//

import UIKit
import IQKeyboardManagerSwift
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UIStoryboard(name: Const.Storyboard.Name.splash, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.splashViewController)
        window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let isDark = defaults.bool(forKey: Const.UserDefaults.darkModeState)
        
        // 시스템 무시하고 UserDefault 상태에 따라 화면 전체에 다크/라이트 모드를 결정
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = isDark == true ? .dark : .light
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }
        
        // 스플래시 지연시간동안 자동 로그인 작업처리
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let acToken = self.defaults.string(forKey: Const.UserDefaults.accessToken)
            let rfToken = self.defaults.string(forKey: Const.UserDefaults.refreshToken)
            
            self.postUserTokenReissue(request: UserTokenReissueRequset(accessToken: acToken ?? "", refreshToken: rfToken ?? ""))
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func postUserTokenReissue(request: UserTokenReissueRequset) {
        UserAPI.shared.userTokenReissue(request: request) { response in
            switch response {
            case .success:
                print("postUserTokenReissue - Success")

                var rootViewController = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil)
                    .instantiateViewController(identifier: Const.ViewController.Identifier.loginViewController)
                
                if self.defaults.string(forKey: Const.UserDefaults.accessToken) != "" {
                    rootViewController = UIStoryboard(name: Const.Storyboard.Name.tabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.tabBarViewController)
                }
                self.window?.rootViewController = rootViewController
                self.window?.makeKeyAndVisible()
            case .requestErr(let message):
                print("postUserTokenReissue - requestErr: \(message)")
                let rootViewController = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil).instantiateViewController(identifier: Const.ViewController.Identifier.loginViewController)
                self.window?.rootViewController = rootViewController
                self.window?.makeKeyAndVisible()
            case .pathErr:
                print("postUserTokenReissue - pathErr")
            case .serverErr:
                print("postUserTokenReissue - serverErr")
            case .networkFail:
                print("postUserTokenReissue - networkFail")
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

