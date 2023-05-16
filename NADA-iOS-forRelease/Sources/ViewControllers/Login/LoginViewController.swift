//
//  LoginViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/09/21.
//

import AuthenticationServices
import UIKit

import FirebaseMessaging
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var nadaImageView: UIImageView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
}
    
// MARK: - Methods

extension LoginViewController {
    private func setUI() {
        let kakaoButton = UIButton()
        kakaoButton.setImage(UIImage(named: "btn_kakaologin"), for: .normal)
        kakaoButton.cornerRadius = 15
        kakaoButton.addTarget(self, action: #selector(kakaoSignInButtonPress), for: .touchUpInside)
        view.addSubview(kakaoButton)
        
        kakaoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            kakaoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoButton.topAnchor.constraint(equalTo: nadaImageView.bottomAnchor, constant: 122),
            kakaoButton.widthAnchor.constraint(equalToConstant: 327),
            kakaoButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        authorizationButton.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
        view.addSubview(authorizationButton)
        
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.topAnchor.constraint(equalTo: kakaoButton.bottomAnchor, constant: 14),
            authorizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorizationButton.widthAnchor.constraint(equalToConstant: 327),
            authorizationButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let isDark = UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.darkModeState)
        
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = isDark == true ? .dark : .light
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    // 메인 화면으로 전환 함수
    func presentToMain() {
        let nextVC = UIStoryboard(name: Const.Storyboard.Name.tabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.tabBarViewController)
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true) {
            UserDefaults.standard.set(false, forKey: Const.UserDefaultsKey.isOnboarding)
        }
    }
    
    private func setFcmTokenAndPostAPI(socialID: String, socialType: String) {
        Messaging.messaging().token { [weak self] token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
//                print("FCM registration token: \(token)")
                self?.postUserSignUpWithAPI(request: UserLoginRequest(socialID: socialID, socialType: socialType, fcmToken: ""))
            }
        }
    }
    
    // MARK: - @objc Mehotds
    
    // 카카오 로그인 버튼 클릭 시
    @objc
    private func kakaoSignInButtonPress() {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            loginWithApp()
        } else {
            // 만약, 카카오톡이 깔려있지 않을 경우에는 웹 브라우저로 카카오 로그인함.
            loginWithWeb()
        }
    }
        
    // 애플 로그인 버튼 클릭 시
    @objc
    func appleSignInButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - KakaoSignIn
extension LoginViewController {
    func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                
                UserApi.shared.me { [weak self] (user, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if let userID = user?.id {
                            self?.setFcmTokenAndPostAPI(socialID: String(userID), socialType: "KAKAO")
                            UserDefaults.standard.set(false, forKey: Const.UserDefaultsKey.isAppleLogin)
                            UserDefaults.standard.set(true, forKey: Const.UserDefaultsKey.isKakaoLogin)
                        }
                    }
                }
            }
        }
        
    }
    
    func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if let userID = user?.id {
                            self?.setFcmTokenAndPostAPI(socialID: String(userID), socialType: "KAKAO")
                            UserDefaults.standard.set(false, forKey: Const.UserDefaultsKey.isAppleLogin)
                            UserDefaults.standard.set(true, forKey: Const.UserDefaultsKey.isKakaoLogin)
                        }
                    }
                }
            }
        }
    }
    
    // 카카오 로그인 표출 함수
    func signUp() {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            loginWithApp()
        } else {
            // 만약, 카카오톡이 깔려있지 않을 경우에는 웹 브라우저로 카카오 로그인함.
            loginWithWeb()
        }
    }
}

// MARK: - AppleSignIn

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            setFcmTokenAndPostAPI(socialID: userIdentifier, socialType: "APPLE")
            UserDefaults.standard.set(true, forKey: Const.UserDefaultsKey.isAppleLogin)
            UserDefaults.standard.set(false, forKey: Const.UserDefaultsKey.isKakaoLogin)
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

// MARK: - Network

extension LoginViewController {
    func postUserSignUpWithAPI(request userLoginRequest: UserLoginRequest) {
        UserAPI.shared.userSocialSignUp(userLoginRequest: userLoginRequest) { response in
            switch response {
            case .success(let loginData):
                print("postUserSignUpWithAPI - success")
                if let userData = loginData as? AccessToken {
                    UserDefaults.standard.set(userLoginRequest.socialID, forKey: Const.UserDefaultsKey.userID)
                    UserDefaults.appGroup.set(userData.accessToken, forKey: Const.UserDefaultsKey.accessToken)
//                    UserDefaults.standard.set(userData.user.token.refreshToken, forKey: Const.UserDefaultsKey.refreshToken)
                    self.presentToMain()
                }
            case .requestErr(let message):
                print("postUserSignUpWithAPI - requestErr: \(message)")
            case .pathErr:
                print("postUserSignUpWithAPI - pathErr")
            case .serverErr:
                print("postUserSignUpWithAPI - serverErr")
            case .networkFail:
                print("postUserSignUpWithAPI - networkFail")
            }
        }
    }
    
}
