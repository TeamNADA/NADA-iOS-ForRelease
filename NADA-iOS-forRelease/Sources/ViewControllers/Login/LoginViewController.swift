//
//  LoginViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/09/21.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: - 서버 연결 테스트, 추후 위치 수정 필요
        // getUserIDFetchWithAPI(userID: "nada")
        // getUserTokenFetchWithAPI(userID: "nada")
        // postUserSignUpWithAPI(request: User(userID: "nada3"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkAutoLogin()
    }
    
    // MARK: - IBAction Properties
    // 카카오톡으로 로그인 버튼 클릭 시
    @IBAction func kakaoLoginButton(_ sender: Any) {
        // 유효한 토큰 검사
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        // 로그인 필요
                        self.signUp()
                    } else {
                        // 기타 에러
                    }
                } else {
                    // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    // ✅ 사용자 정보를 가져오고 화면전환을 하는 커스텀 메서드
                    self.getUserInfo()
                }
            }
        } else {
            // 카카오 토큰 없음 -> 로그인 필요
            self.signUp()
        }
    }
    
    // Apple로 로그인 버튼 클릭 시
    @IBAction func appleLoginButton(_ sender: Any) {
        
    }
}

// MARK: - Extensions
extension LoginViewController {
    // 메인 화면으로 전환 함수
    func goToMain() {
        let nextVC = UIStoryboard(name: Const.Storyboard.Name.tabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.tabBarViewController)
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    // 카카오 로그인 표출 함수
    func signUp() {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {  // 예외 처리 (로그인 취소 등)
                    print(error)
                } else {                // 로그인 성공했을 때
                    print("loginWithKakaoTalk() success.")
                    self.getUserInfo()
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                    self.goToMain()
                }
            }
        } else {
            // 만약, 카카오톡이 깔려있지 않을 경우에는 웹 브라우저로 카카오 로그인함.
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {  // 예외 처리 (로그인 취소 등)
                    print(error)
                } else {                // 로그인 성공했을 때
                    print("loginWithKakaoTalk() success.")
                    self.getUserInfo()
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                    self.goToMain()
                }
            }
        }
    }
    
    // 사용자 정보를 성공적으로 가져왔을 때, 화면전환하는 함수
    private func getUserInfo() {
        // 사용자 정보 가져오기
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            } else {
                print("me() success.")
                let email = user?.kakaoAccount?.email   // 이메일 정보
            }
        }
    }
    
    // 자동 로그인 체크 함수
    func checkAutoLogin() {
        
    }
}

// MARK: - Network
extension LoginViewController {
    func getUserIDFetchWithAPI(userID: String) {
        UserAPI.shared.userIDFetch(userID: userID) { response in
            switch response {
            case .success(let data):
                print(data)
            case .requestErr(let message):
                print("getUserIDFetchWithAPI - requestErr", message)
            case .pathErr:
                print("getUserIDFetchWithAPI - pathErr")
            case .serverErr:
                print("getUserIDFetchWithAPI - serverErr")
            case .networkFail:
                print("getUserIDFetchWithAPI - networkFail")
            }
        }
    }
    
    func getUserTokenFetchWithAPI(userID: String) {
        UserAPI.shared.userTokenFetch(userID: userID) { response in
            switch response {
            case .success(let data):
                print(data)
            case .requestErr(let message):
                print("getUserTokenFetchWithAPI - requestErr", message)
            case .pathErr:
                print("getUserTokenFetchWithAPI - pathErr")
            case .serverErr:
                print("getUserTokenFetchWithAPI - serverErr")
            case .networkFail:
                print("getUserTokenFetchWithAPI - networkFail")
            }
        }
    }
    
    func postUserSignUpWithAPI(request: User) {
        UserAPI.shared.userSignUp(request: request) { response in
            switch response {
            case .success:
                print("postUserSignUpWithAPI - success")
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
