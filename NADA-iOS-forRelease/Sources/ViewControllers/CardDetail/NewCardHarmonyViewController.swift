//
//  NewCardHarmonyViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/05/08.
//

import UIKit

import Kingfisher
import Lottie
import NVActivityIndicatorView
import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then

class NewCardHarmonyViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Components
    
    private let xButton = UIButton().then {
        $0.setImage(UIImage(named: "iconClear"), for: .normal)
        $0.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
    }
    
    private let popUpView = UIView().then {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 22
    }
    
    private let mbtiIcon = UIImageView().then {
        $0.image = UIImage(named: "iconMbti")
    }
    
    private let mbtiTitleLabel = UILabel().then {
        $0.font = .textRegular03
        $0.text = "MBTI 점수"
        $0.textColor = .secondary
        $0.sizeToFit()
    }
    
    private let mbtiScoreLabel = UILabel().then {
        $0.font = .textBold01
        $0.text = "NN점"
        $0.textColor = .secondary
        $0.sizeToFit()
    }
    
    private let dividerLine = UIView().then {
        $0.backgroundColor = .quaternary
    }
    
    private let starIcon = UIImageView().then {
        $0.image = UIImage(named: "iconStar")
    }
    
    private let starTitleLabel = UILabel().then {
        $0.font = .textRegular03
        $0.text = "별자리 점수"
        $0.textColor = .secondary
        $0.sizeToFit()
    }
    
    private let starScoreLabel = UILabel().then {
        $0.font = .textBold01
        $0.text = "NN점"
        $0.textColor = .secondary
        $0.sizeToFit()
    }
    
    private let nadaDescLabel = UILabel().then {
        $0.font = .button02
        $0.text = "NADA만의 랜덤 점수까지 더하면!"
        $0.textColor = .tertiary
        $0.sizeToFit()
    }
    
    private let nadaHarmonyLottie020 = LottieAnimationView(name: Const.Lottie.onboarding01)
    private let nadaHarmonyLottie2140 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie2140)
    private let nadaHarmonyLottie4160 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie4160)
    private let nadaHarmonyLottie6180 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie6180)
    private let nadaHarmonyLottie81100 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie81100)
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - Extensions

extension NewCardHarmonyViewController {
    
    // MARK: UI & Layout
    
    private func setUI() {
        nadaHarmonyLottie020.loopMode = .playOnce
        nadaHarmonyLottie2140.loopMode = .playOnce
        nadaHarmonyLottie4160.loopMode = .playOnce
        nadaHarmonyLottie6180.loopMode = .playOnce
        nadaHarmonyLottie81100.loopMode = .playOnce
        
//        onboardingFirstLottieView.play()
    }
    
    private func setLayout() {
        
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissPopUp() {
        self.dismiss(animated: false)
    }
    
}
