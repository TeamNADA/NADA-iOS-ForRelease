//
//  HomeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/06.
//

import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then
import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties
    
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    
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
        bindActions()
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
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(12)
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
        giveCardIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(6)
            make.width.height.equalTo(90)
        }
        takeCardIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(6)
            make.width.height.equalTo(90)
        }
        aroundMeIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.width.height.equalTo(90)
        }
    }
    
    // MARK: - Methods
    
    private func bindActions() {
        giveCardImageView.rx.tapGesture()
            .when(.recognized) // bind시에도 이벤트가 발생하기 때문 .skip(1)으로도 처리 가능
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                print("명함 주기")
            }.disposed(by: self.disposeBag)
        
        takeCardImageView.rx.tapGesture()
            .when(.recognized) // bind시에도 이벤트가 발생하기 때문 .skip(1)으로도 처리 가능
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                print("명함 받기")
            }.disposed(by: self.disposeBag)
        
        aroundMeImageView.rx.tapGesture()
            .when(.recognized) // bind시에도 이벤트가 발생하기 때문 .skip(1)으로도 처리 가능
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                let aroundMeVC = self.moduleFactory.makeAroundMeVC()
                owner.present(aroundMeVC, animated: true)
            }.disposed(by: self.disposeBag)
    }
}
