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
        // deleteUserWithAPI(userID: "nada3")
    }
    
    // MARK: - IBAction Properties
    // 카카오톡으로 로그인 버튼 클릭 시
    @IBAction func kakaoLoginButton(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    // do something
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                }
            }
        } else {
            // 웹 브라우저로 카카오 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")

                    // do something
                    _ = oauthToken
                }
            }
        }
    }
    
    // Apple로 로그인 버튼 클릭 시
    @IBAction func appleLoginButton(_ sender: Any) {
        
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
    
    // FIXME: - 계정 탈퇴 네트워크 함수 추후 위치 수정
    func deleteUserWithAPI(userID: String) {
        UserAPI.shared.userDelete(userID: userID) { response in
            switch response {
            case .success:
                print("deleteUserWithAPI - success")
            case .requestErr(let message):
                print("deleteUserWithAPI - requestErr: \(message)")
            case .pathErr:
                print("deleteUserWithAPI - pathErr")
            case .serverErr:
                print("deleteUserWithAPI - serverErr")
            case .networkFail:
                print("deleteUserWithAPI - networkFail")
            }
        }
    }
}
