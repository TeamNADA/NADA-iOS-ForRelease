//
//  LoginViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/09/21.
//

import UIKit

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
        
    }
    
    // Apple로 로그인 버튼 클릭 시
    @IBAction func appleLoginButton(_ sender: Any) {
        
    }
}

// MARK: - Network
extension LoginViewController {
    func getUserIDFetchWithAPI(userID: String) {
        UserAPI.shared.getUserIDFetch(userID: userID) { response in
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
        UserAPI.shared.getUserTokenFetch(userID: userID) { response in
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
        UserAPI.shared.postUserSignUp(request: request) { response in
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
        UserAPI.shared.deleteUser(userID: userID) { response in
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
