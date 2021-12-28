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
    let defaults = UserDefaults.standard
 
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if self.appDelegate?.isLogin == true {
                self.presentToMain()
            } else {
                self.presentToLogin()
            }
        }
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
