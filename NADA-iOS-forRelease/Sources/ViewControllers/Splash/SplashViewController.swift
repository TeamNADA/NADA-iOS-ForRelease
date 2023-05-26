//
//  SplashViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/07.
//

import UIKit

import FirebaseAnalytics
import Lottie
import SnapKit

class SplashViewController: UIViewController {

    // MARK: - Properties
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let nadaLogoLottieView = LottieAnimationView(name: Const.Lottie.nadaLogo)
    
    let defaults = UserDefaults.standard
 
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setLottie()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
    
    // MARK: - Functions
    
    private func setLottie() {
        nadaLogoLottieView.play { [weak self] _ in
            self?.presentScreen()
        }
    }
    private func presentScreen() {
        if self.appDelegate?.isLogin == true {
            self.presentToMain()
        } else {
            if UserDefaults.standard.object(forKey: Const.UserDefaultsKey.isOnboarding) != nil {
                self.presentToLogin()
            } else {
                self.presentToOnboarding()
            }
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
    private func presentToOnboarding() {
        guard let onboardingVC = UIStoryboard(name: Const.Storyboard.Name.onboarding, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.onboardingViewController) as? OnboardingViewController else { return }
        onboardingVC.modalPresentationStyle = .fullScreen
        onboardingVC.modalTransitionStyle = .crossDissolve
        self.present(onboardingVC, animated: true, completion: nil)
    }
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.splash
                           ])
    }
}

// MARK: - Layout

extension SplashViewController {
    private func setLayout() {
        view.addSubview(nadaLogoLottieView)
        
        nadaLogoLottieView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(160)
        }
    }
}
