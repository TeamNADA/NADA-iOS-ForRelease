//
//  HomeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/06.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - UI Components
    private let nadaIcon = UIImageView().then {
        $0.image = UIImage(named: "nadaLogoTxt")
    }
    private let giveCardImageView = UIImageView().then {
        $0.image = UIImage(named: "cardVertical")
    }
    private let takeCardImageView = UIImageView().then {
        $0.image = UIImage(named: "cardVertical")
    }
    private let aroundMeImageView = UIImageView().then {
        $0.image = UIImage(named: "cardHorizon")
    }
    private let giveCardLabel = UILabel().then {
        $0.text = "명함 주기"
        $0.font = UIFont.title02
    }
    private let takeCardLabel = UILabel().then {
        $0.text = "명함 받기"
        $0.font = UIFont.title02
    }
    private let aroundMeLabel = UILabel().then {
        $0.text = "내 근처의 명함"
        $0.font = UIFont.title02
    }
    private let giveCardIcon = UIImageView().then {
        $0.backgroundColor = .blue
    }
    private let takeCardIcon = UIImageView().then {
        $0.backgroundColor = .blue
    }
    private let aroundMeIcon = UIImageView().then {
        $0.backgroundColor = .blue
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }

}

extension HomeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews([nadaIcon, giveCardImageView, takeCardImageView, aroundMeImageView])
        giveCardImageView.addSubviews([giveCardLabel, giveCardIcon])
        takeCardImageView.addSubviews([takeCardLabel, takeCardIcon])
        aroundMeImageView.addSubviews([aroundMeLabel, aroundMeIcon])
        
        nadaIcon.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(19)
        }
        giveCardImageView.snp.makeConstraints { make in
            make.top.equalTo(nadaIcon.snp.bottom).offset(150)
            make.leading.equalToSuperview().inset(24)
        }
        takeCardImageView.snp.makeConstraints { make in
            make.top.equalTo(nadaIcon.snp.bottom).offset(150)
            make.trailing.equalToSuperview().inset(24)
        }
        aroundMeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(giveCardImageView.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(24)
        }
        giveCardLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(12)
        }
        takeCardLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(12)
        }
        aroundMeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Methods
}
