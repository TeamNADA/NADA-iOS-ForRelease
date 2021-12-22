//
//  SplashViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/07.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - Properties
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    // MARK: - @IBOutlet Properties
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        postUserTokenReissue(request: UserTokenReissueRequset(accessToken: UserDefaults.standard.string(forKey: Const.UserDefaults.accessToken)!, refreshToken: UserDefaults.standard.string(forKey: Const.UserDefaults.refreshToken)!))
    }
    
    // MARK: - Functions
    private func presentToMain() {
        guard let mainVC = UIStoryboard(name: Const.Storyboard.Name.tabBar, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.tabBarViewController) as? TabBarViewController else { return }
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true, completion: nil)
    }
    
    private func presentToLogin() {
        guard let loginVC = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.loginViewController) as? LoginViewController else { return }
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        self.present(loginVC, animated: true, completion: nil)
    }
    
}

// MARK: - Networks
extension SplashViewController {
    
    func postUserTokenReissue(request: UserTokenReissueRequset) {
        UserAPI.shared.userTokenReissue(request: request) { response in
            switch response {
            case .success:
                print("postUserTokenReissue - Success")
            case .requestErr(let message):
                print("postUserTokenReissue - requestErr: \(message)")
                self.presentToLogin()
            case .pathErr:
                print("postUserTokenReissue - pathErr")
            case .serverErr:
                print("postUserTokenReissue - serverErr")
            case .networkFail:
                print("postUserTokenReissue - networkFail")
            }
        }
    }
}
