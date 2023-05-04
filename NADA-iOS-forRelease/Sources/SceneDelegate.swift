//
//  SceneDelegate.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/08/08.
//

import Photos
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
        let myCardURL = "openMyCardWidget"
        let qrCodeURL = "openQRCodeWidget"

        guard let url = URLContexts.first?.url,
              let urlComponents = URLComponents(string: url.absoluteString) else { return }
        
        if qrCodeURL == url.absoluteString {
            // qr code 위젯.
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                window?.rootViewController?.makeOKCancelAlert(title: "카메라 권한이 허용되어 있지 않아요.",
                            message: "QR코드 인식을 위해 카메라 권한이 필요합니다. 앱 설정으로 이동해 허용해 주세요.",
                            okAction: { _ in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)},
                            cancelAction: nil,
                            completion: nil)
            case .authorized:
                guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
                nextVC.modalPresentationStyle = .overFullScreen
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    let topVC = UIApplication.mostTopViewController()
                    topVC?.present(nextVC, animated: true)
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
                            nextVC.modalPresentationStyle = .overFullScreen
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                let topVC = UIApplication.mostTopViewController()
                                topVC?.present(nextVC, animated: true)
                            }
                        }
                    }
                }
            default:
                break
            }
        } else if url.absoluteString.starts(with: myCardURL) {
            // 내 명함 위젯.
            guard let queryItems = urlComponents.queryItems,
                  let cardUUID = queryItems.filter({ $0.name == "cardUUID" }).first?.value else { return }
            
            let nextVC = CardShareBottomSheetViewController()
                .setTitle("명함공유")
                .setHeight(606.0)

            nextVC.cardDataModel = Card(birth: "", cardID: 0, cardUUID: cardUUID, cardImage: "imgCardBg01", cardName: "첫 번째 카드", cardTastes: [CardTasteInfo(cardTasteName: "", isChoose: false, sortOrder: 0)], cardType: "", departmentName: "", isRepresentative: false, mailAddress: "", mbti: "", phoneNumber: "", instagram: "", twitter: "", tmi: "", urls: [], userName: "1현규")
            
            nextVC.isActivate = false
            nextVC.modalPresentationStyle = .overFullScreen
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let topVC = UIApplication.mostTopViewController()
                topVC?.present(nextVC, animated: true)
            }
        } else {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
                if let cardUUID = self.handleDynamicLink(dynamicLink) {
                    NotificationCenter.default.post(name: .presentDynamicLink, object: cardUUID)
                    UserDefaults.standard.setValue(cardUUID, forKey: Const.UserDefaultsKey.dynamicLinkCardUUID)
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
