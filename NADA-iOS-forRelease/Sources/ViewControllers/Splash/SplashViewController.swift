//
//  SplashViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/07.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - Properties
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate

    // MARK: - @IBOutlet Properties
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self.setIsLogin()
        }
    }
    
    // MARK: - Functions
    private func setIsLogin() {
        if appDelegate?.isLogin == true {
            presentToMain()
        } else {
            presentToLogin()
        }
    }
    
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
