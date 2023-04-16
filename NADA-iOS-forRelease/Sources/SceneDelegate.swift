//
//  SceneDelegate.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/08/08.
//

import UIKit

import FirebaseDynamicLinks
import IQKeyboardManagerSwift
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = ModuleFactory.shared.makeSplashVC()
        window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let isDark = defaults.bool(forKey: Const.UserDefaultsKey.darkModeState)
        
        // 시스템 무시하고 UserDefault 상태에 따라 화면 전체에 다크/라이트 모드를 결정
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = isDark == true ? .dark : .light
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }
        
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
                if let cardUUID = self.handleDynamicLink(dynamicLink) {
                    UserDefaults.standard.set(cardUUID, forKey: Const.UserDefaultsKey.dynamicLinkCardUUID)
                }
            }
        }
    }
    
    // MARK: - Methods
    
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

// MARK: - Extensions

extension SceneDelegate {
    private func handleDynamicLink(_ dynamicLink: DynamicLink?) -> String? {
        guard let dynamicLink = dynamicLink,
              let link = dynamicLink.url else { return nil }
        
        let queryItems = URLComponents(url: link, resolvingAgainstBaseURL: true)?.queryItems
        let cardUUID = queryItems?.filter { $0.name == "cardUUID" }.first?.value
        
        return cardUUID
    }
}
