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
        getUserIDFetchWithAPI(userID: "nada")
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
}
