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
        $0.image = UIImage(named: "iconMbtiBlack")
        $0.alpha = 0
    }
    
    private let mbtiTitleLabel = UILabel().then {
        $0.font = .textRegular03
        $0.text = "MBTI 점수"
        $0.textColor = .secondary
        $0.sizeToFit()
        $0.alpha = 0
    }
    
    private let mbtiScoreLabel = UILabel().then {
        $0.font = .textBold01
        $0.text = "NN점"
        $0.textColor = .secondary
        $0.sizeToFit()
        $0.alpha = 0
    }
    
    private let dividerLine = UIView().then {
        $0.backgroundColor = .quaternary
        $0.alpha = 0
    }
    
    private let starIcon = UIImageView().then {
        $0.image = UIImage(named: "iconStar")
        $0.alpha = 0
    }
    
    private let starTitleLabel = UILabel().then {
        $0.font = .textRegular03
        $0.text = "별자리 점수"
        $0.textColor = .secondary
        $0.sizeToFit()
        $0.alpha = 0
    }
    
    private let starScoreLabel = UILabel().then {
        $0.font = .textBold01
        $0.text = "NN점"
        $0.textColor = .secondary
        $0.sizeToFit()
        $0.alpha = 0
    }
    
    private let nadaDescLabel = UILabel().then {
        $0.font = .button02
        $0.text = "NADA만의 랜덤 점수까지 더하면!"
        $0.textColor = .tertiary
        $0.sizeToFit()
        $0.alpha = 0
    }
    
    private let nadaHarmonyLottie020 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie020).then {
        $0.isHidden = true
    }
    private let nadaHarmonyLottie2140 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie2140).then {
        $0.isHidden = true
    }
    private let nadaHarmonyLottie4160 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie4160).then {
        $0.isHidden = true
    }
    private let nadaHarmonyLottie6180 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie6180).then {
        $0.isHidden = true
    }
    private let nadaHarmonyLottie81100 = LottieAnimationView(name: Const.Lottie.nadaHarmonyLottie81100).then {
        $0.isHidden = true
    }
    
    private let scoreTitleLabel = UILabel().then {
        $0.font = .harmonyTitle01
        $0.text = "우리 궁합은 nn점!"
        $0.textColor = .harmonyRed
        $0.sizeToFit()
        $0.alpha = 0
    }
    
    private let scoreDescLabel = UILabel().then {
        $0.font = .textBold01
        $0.text = "좀 더 친해지길 바래"
        $0.textColor = .primary
        $0.sizeToFit()
        $0.alpha = 0
    }
    
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
        view.backgroundColor = .black.withAlphaComponent(0.4)
        nadaHarmonyLottie020.loopMode = .playOnce
        nadaHarmonyLottie2140.loopMode = .playOnce
        nadaHarmonyLottie4160.loopMode = .playOnce
        nadaHarmonyLottie6180.loopMode = .playOnce
        nadaHarmonyLottie81100.loopMode = .playOnce
    }
    
    private func setLayout() {
        view.addSubviews([popUpView])
        popUpView.addSubviews([xButton, mbtiIcon, mbtiTitleLabel, mbtiScoreLabel,
                               dividerLine, starIcon, starTitleLabel, starScoreLabel,
                               nadaDescLabel, nadaHarmonyLottie020, nadaHarmonyLottie2140, nadaHarmonyLottie4160,
                               nadaHarmonyLottie6180, nadaHarmonyLottie81100, scoreTitleLabel, scoreDescLabel])
        
        popUpView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().inset(17)
            make.height.equalTo(470)
        }
        xButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        mbtiIcon.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(31)
            make.leading.equalToSuperview().inset(52)
            make.width.height.equalTo(18)
        }
        mbtiTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mbtiIcon.snp.centerY)
            make.leading.equalTo(mbtiIcon.snp.trailing).offset(2)
        }
        mbtiScoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mbtiIcon.snp.centerY)
            make.trailing.equalToSuperview().inset(52)
        }
        dividerLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mbtiIcon.snp.bottom).offset(11.5)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        starIcon.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(10.5)
            make.leading.equalToSuperview().inset(52)
            make.width.height.equalTo(18)
        }
        starTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starIcon.snp.centerY)
            make.leading.equalTo(starIcon.snp.trailing).offset(2)
        }
        starScoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starIcon.snp.centerY)
            make.trailing.equalToSuperview().inset(52)
        }
        nadaDescLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(starIcon.snp.bottom).offset(24)
        }
        nadaHarmonyLottie020.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nadaDescLabel.snp.bottom).offset(20)
            make.width.height.equalTo(147)
        }
        nadaHarmonyLottie2140.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nadaDescLabel.snp.bottom).offset(20)
            make.width.height.equalTo(147)
        }
        nadaHarmonyLottie4160.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nadaDescLabel.snp.bottom).offset(20)
            make.width.height.equalTo(147)
        }
        nadaHarmonyLottie6180.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nadaDescLabel.snp.bottom).offset(20)
            make.width.height.equalTo(147)
        }
        nadaHarmonyLottie81100.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nadaDescLabel.snp.bottom).offset(20)
            make.width.height.equalTo(147)
        }
        scoreDescLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(37)
        }
        scoreTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(scoreDescLabel.snp.top).offset(-10)
        }
    }
    
    // MARK: - Methods
    
    private func setAnimation(_ lottie: LottieAnimationView) {
        UIView.animate(withDuration: 0.6, animations: {
            self.mbtiIcon.alpha = 1
            self.mbtiTitleLabel.alpha = 1
            self.mbtiScoreLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 1.0, animations: {
                self.dividerLine.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: 0.6, delay: 1.0, animations: {
                    self.starIcon.alpha = 1
                    self.starTitleLabel.alpha = 1
                    self.starScoreLabel.alpha = 1
                }, completion: { _ in
                    UIView.animate(withDuration: 0.6, delay: 1.0, animations: {
                        self.nadaDescLabel.alpha = 1
                    }, completion: { _ in
                        UIView.animate(withDuration: 3.0, delay: 1.5, animations: {
                            lottie.isHidden = false
                            lottie.play()
                        }, completion: { _ in
                            UIView.animate(withDuration: 0.6, delay: 1.0, animations: {
                                self.scoreTitleLabel.alpha = 1
                                self.scoreDescLabel.alpha = 1
                            })
                        })
                    })
                })
            })
        })
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissPopUp() {
        self.dismiss(animated: false)
    }
    
}
