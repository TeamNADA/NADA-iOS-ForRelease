//
//  HomeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/06.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then

final class HomeViewController: UIViewController {

    // MARK: - Properties
    
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let nadaIcon = UIImageView().then {
        $0.image = UIImage(named: "nadaLogoTxt")
    }
    private let giveCardView = UIView().then {
        $0.backgroundColor = .cardCreationUnclicked
        $0.layer.cornerRadius = 15
    }
    private let takeCardView = UIView().then {
        $0.backgroundColor = .cardCreationUnclicked
        $0.layer.cornerRadius = 15
    }
    private let aroundMeView = UIView().then {
        $0.backgroundColor = .cardCreationUnclicked
        $0.layer.cornerRadius = 15
    }
    private let giveCardLabel = UILabel().then {
        $0.text = "명함 보내기"
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
        $0.image = UIImage(named: "imgSend")
    }
    private let takeCardIcon = UIImageView().then {
        $0.image = UIImage(named: "imgRecieve")
    }
    private let aroundMeIcon = UIImageView().then {
        $0.image = UIImage(named: "imgNearby")
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindActions()
        checkUpdateVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUI()
    }
}

extension HomeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .background
        self.navigationController?.navigationBar.isHidden = true
        giveCardView.backgroundColor = .cardCreationUnclicked
        takeCardView.backgroundColor = .cardCreationUnclicked
        aroundMeView.backgroundColor = .cardCreationUnclicked
    }
    
    private func setLayout() {
        view.addSubviews([nadaIcon, giveCardView, takeCardView, aroundMeView])
        giveCardView.addSubviews([giveCardLabel, giveCardIcon])
        takeCardView.addSubviews([takeCardLabel, takeCardIcon])
        aroundMeView.addSubviews([aroundMeLabel, aroundMeIcon])
        
        nadaIcon.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            make.leading.equalToSuperview().inset(19)
        }
        giveCardView.snp.makeConstraints { make in
            make.top.equalTo(nadaIcon.snp.bottom).offset(150)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(157)
            make.height.equalTo(205)
        }
        takeCardView.snp.makeConstraints { make in
            make.top.equalTo(nadaIcon.snp.bottom).offset(150)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(157)
            make.height.equalTo(205)
        }
        aroundMeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(giveCardView.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(100)
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
        }
        takeCardIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(6)
        }
        aroundMeIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Methods
    
    private func bindActions() {
        giveCardView.rx.tapGesture()
            .when(.recognized) // bind시에도 이벤트가 발생하기 때문 .skip(1)으로도 처리 가능
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                owner.giveCardView.backgroundColor = .cardCreationClicked
                print("명함 주기")
            }.disposed(by: self.disposeBag)
        
        takeCardView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                owner.takeCardView.backgroundColor = .cardCreationClicked
                print("명함 받기")
                let nextVC = ReceiveCardBottomSheetViewController()
                            .setTitle("명함 받기")
                            .setHeight(285)
                nextVC.modalPresentationStyle = .overFullScreen
                self.present(nextVC, animated: false, completion: nil)
            }.disposed(by: self.disposeBag)
        
        aroundMeView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                owner.aroundMeView.backgroundColor = .cardCreationClicked
                let aroundMeVC = self.moduleFactory.makeAroundMeVC()
                owner.present(aroundMeVC, animated: true)
            }.disposed(by: self.disposeBag)
    }
    
    private func checkUpdateVersion() {
        updateUserInfoFetchWithAPI { [weak self] checkUpdateNote in
            if !checkUpdateNote {
                self?.updateNoteFetchWithAPI { [weak self] updateNote in
                    if self?.checkUpdateAvailable(updateNote.latestVersion) ?? false {
                        self?.presentToUpdateVC(with: updateNote)
                        UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.dynamicLinkCardUUID)
                    } else {
                        if let dynamicLinkCardUUID = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.dynamicLinkCardUUID) {
                            self?.checkDynamicLink(dynamicLinkCardUUID)
                        }
                    }
                }
            } else {
                if let dynamicLinkCardUUID = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.dynamicLinkCardUUID) {
                    self?.checkDynamicLink(dynamicLinkCardUUID)
                }
            }
        }
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
    
    private func presentToUpdateVC(with updateNote: UpdateNote?) {
        let updateVC = ModuleFactory.shared.makeUpdateVC()
        updateVC.updateNote = updateNote
        self.present(updateVC, animated: true)
    }
    
    private func checkDynamicLink(_ dynamicLinkCardUUID: String) {
        self.cardDetailFetchWithAPI(cardUUID: dynamicLinkCardUUID) { [weak self] cardDataModel in
            self?.cardAddInGroupWithAPI(cardUUID: dynamicLinkCardUUID) { [weak self] in
                UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.dynamicLinkCardUUID)
                self?.presentToCardDetailVC(cardDataModel: cardDataModel)
            }
        }
    }
    
    private func presentToCardDetailVC(cardDataModel: Card) {
        let cardDetailVC = moduleFactory.makeCardDetailVC()
        cardDetailVC.status = .add
        cardDetailVC.cardDataModel = cardDataModel
        self.present(cardDetailVC, animated: true)
    }
    
    private func presentQRScanVC() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            makeOKCancelAlert(title: "카메라 권한이 허용되어 있지 않아요.",
                        message: "QR코드 인식을 위해 카메라 권한이 필요합니다. 앱 설정으로 이동해 허용해 주세요.",
                        okAction: { _ in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)},
                        cancelAction: nil,
                        completion: nil)
        case .authorized:
            guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true, completion: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
                        nextVC.modalPresentationStyle = .overFullScreen
                        self.present(nextVC, animated: true, completion: nil)
                    }
                }
            }
        default:
            break
        }
    }
    
    private func presentCardShareBottomSheetVC(with cardUUID: String) {
        self.cardDetailFetchWithAPI(cardUUID: cardUUID) { [weak self] cardDataModel in
            let nextVC = CardShareBottomSheetViewController()
                .setTitle("명함공유")
                .setHeight(606.0)
            
            nextVC.isActivate = false
            nextVC.modalPresentationStyle = .overFullScreen
            nextVC.cardDataModel = cardDataModel
            
            self?.present(nextVC, animated: true)
        }
    }
}

// MARK: - Network
extension HomeViewController {
    private func updateUserInfoFetchWithAPI(completion: @escaping (Bool) -> Void) {
        UpdateAPI.shared.updateUserInfoFetch { response in
            switch response {
            case .success(let data):
                guard let updateUserInfo = data as? UpdateUserInfo else { return }
                completion(updateUserInfo.checkUpdateNote)
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
    private func updateNoteFetchWithAPI(completion: @escaping (UpdateNote) -> Void) {
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
    private func cardDetailFetchWithAPI(cardUUID: String, completion: @escaping (Card) -> Void) {
        CardAPI.shared.cardDetailFetch(cardUUID: cardUUID) { response in
            switch response {
            case .success(let data):
                if let cardDataModel = data as? Card {
                    completion(cardDataModel)
                }
                print("cardDetailFetchWithAPI - success")
            case .requestErr(let message):
                print("cardDetailFetchWithAPI - requestErr", message)
            case .pathErr:
                print("cardDetailFetchWithAPI - pathErr")
            case .serverErr:
                print("cardDetailFetchWithAPI - serverErr")
            case .networkFail:
                print("deleteGroupWithAPI - networkFail")
            }
        }
    }
    private func cardAddInGroupWithAPI(cardUUID: String, completion: @escaping () -> Void) {
        GroupAPI.shared.cardAddInGroup(cardRequest: CardAddInGroupRequest(cardGroupName: "미분류", cardUUID: cardUUID)) { response in
            switch response {
            case .success:
                completion()
                print("cardAddInGroupWithAPI - success")
            case .requestErr(let message):
                print("cardAddInGroupWithAPI - requestErr", message)
            case .pathErr:
                print("cardAddInGroupWithAPI - pathErr")
            case .serverErr:
                print("cardAddInGroupWithAPI - serverErr")
            case .networkFail:
                print("cardAddInGroupWithAPI - networkFail")
            }
        }
    }
}
