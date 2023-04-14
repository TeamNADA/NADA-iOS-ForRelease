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
        checkUpdateVersion()
    }
}

extension HomeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .background
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
    
    private func checkUpdateAvailable(_ latestVersion: String) -> Bool {
        var latestVersion = latestVersion
        latestVersion.removeFirst()
        
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return false }
        let currentVersionArray = currentVersion.split(separator: ".").map { $0 }
        let appStoreVersionArray = latestVersion.split(separator: ".").map { $0 }
        
        if currentVersionArray[0] < appStoreVersionArray[0] {
            return true
        } else {
            return currentVersionArray[1] < appStoreVersionArray[1] ? true : false
        }
    }
    
    private func checkUpdateVersion() {
        updateUserInfoFetchWithAPI { [weak self] forceUpdateAgreement in
            if !forceUpdateAgreement {
                self?.updateNoteFetchWithAPI { [weak self] updateNote in
                    if self?.checkUpdateAvailable(updateNote.latestVersion) ?? false {
                        self?.presentToUpdateVC(with: updateNote)
                    }
                }
            }
        }
    }

    private func presentToUpdateVC(with updateNote: UpdateNote?) {
        let updateVC = ModuleFactory.shared.makeUpdateVC()
        updateVC.updateNote = updateNote
        self.present(updateVC, animated: true)
    }
}

// MARK: - Network
extension HomeViewController {
    func updateUserInfoFetchWithAPI(completion: @escaping (Bool) -> Void) {
        UpdateAPI.shared.updateUserInfoFetch { response in
            switch response {
            case .success(let data):
                guard let updateUserInfo = data as? UpdateUserInfo else { return }
                completion(updateUserInfo.forceUpdateAgreement)
                print("getUpdateNoteFetchWithAPI - success")
            case .requestErr(let message):
                print("getUpdateUserInfoFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getUpdateUserInfoFetchWithAPI - pathErr")
            case .serverErr:
                print("getUpdateUserInfoFetchWithAPI - serverErr")
            case .networkFail:
                print("getUpdateUserInfoFetchWithAPI - networkFail")
            }
        }
    }
    func updateNoteFetchWithAPI(completion: @escaping (UpdateNote) -> Void) {
        UpdateAPI.shared.updateNoteFetch { response in
            switch response {
            case .success(let data):
                guard let updateNote = data as? UpdateNote else { return }
                completion(updateNote)
                print("getUpdateNoteFetchWithAPI - success")
            case .requestErr(let message):
                print("getUpdateNoteFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("getUpdateNoteFetchWithAPI - pathErr")
            case .serverErr:
                print("getUpdateNoteFetchWithAPI - serverErr")
            case .networkFail:
                print("getUpdateNoteFetchWithAPI - networkFail")
            }
            
        }
    }
}
