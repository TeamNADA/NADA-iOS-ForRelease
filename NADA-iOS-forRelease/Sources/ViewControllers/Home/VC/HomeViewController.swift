//
//  HomeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/06.
//

import Photos
import UIKit

import FirebaseAnalytics
import GoogleMobileAds
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
    
    private var banners: [BannerResponse] = []
    
    // MARK: - UI Components
    
    private let bannerBackView = UIView().then {
        $0.backgroundColor = .card
    }
    private let bannerCollevtionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
        $0.scrollDirection = .horizontal
    }
    private lazy var bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: bannerCollevtionViewFlowLayout).then {
        $0.isPagingEnabled = false
        $0.clipsToBounds = true
        $0.decelerationRate = .fast
        $0.backgroundColor = .card
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private var bannerPageLabel = UILabel().then {
        $0.font = .textRegular05
        $0.textColor = .quaternary
        $0.text = "NN/NN"
    }
    private let tryCardView = UIView().then {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = false
    }
    private let tryCardIcon = UIImageView().then {
        $0.image = UIImage(named: "icnTryCard")
    }
    private let tryCardLabel = UILabel().then {
        $0.text = "내 명함을 만들어 보세요!"
        $0.font = .textRegular03
        $0.addCharacterFontColor(color: .mainColorNadaMain, font: .textBold01, range: "내 명함")
    }
    private let tryCardArrowIcon = UIImageView().then {
        $0.image = UIImage(named: "iconArrowRight")
    }
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
    private let stackview = UIStackView().then {
        $0.spacing = 15
        $0.distribution = .fillEqually
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
    private var googleAdView = GADBannerView()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindActions()
        setDelegate()
        setRegister()
        checkUpdateVersionAndSetting()
        setNotification()
        bannerFetchWithAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
}

extension HomeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        setGoogleAd()
        self.view.backgroundColor = .background
        self.navigationController?.navigationBar.isHidden = true
        giveCardView.backgroundColor = .cardCreationUnclicked
        takeCardView.backgroundColor = .cardCreationUnclicked
        aroundMeView.backgroundColor = .cardCreationUnclicked
        self.traitCollection.performAsCurrent {
            tryCardView.layer.borderWidth = 1
            tryCardView.layer.borderColor = UIColor.button.cgColor
        }
    }
    
    private func setLayout() {
        stackview.addArrangedSubviews([giveCardView, takeCardView])
        bannerBackView.addSubviews([nadaIcon, bannerCollectionView, bannerPageLabel])
        tryCardView.addSubviews([tryCardIcon, tryCardLabel, tryCardArrowIcon])
        view.addSubviews([bannerBackView, tryCardView, stackview, aroundMeView, googleAdView])
        giveCardView.addSubviews([giveCardLabel, giveCardIcon])
        takeCardView.addSubviews([takeCardLabel, takeCardIcon])
        aroundMeView.addSubviews([aroundMeLabel, aroundMeIcon])
        
        bannerBackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(172)
        }
        nadaIcon.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(12)
            make.leading.equalToSuperview().inset(19)
        }
        bannerPageLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(8)
        }
        bannerCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nadaIcon.snp.bottom).offset(11)
            make.bottom.equalTo(bannerPageLabel.snp.top).inset(-8)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview()
        }
        tryCardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bannerBackView.snp.bottom).offset(54)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        stackview.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tryCardView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(205)
        }
        aroundMeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(giveCardView.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(100)
        }
        tryCardIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
        tryCardLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(tryCardIcon.snp.trailing).offset(5)
        }
        tryCardArrowIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
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
    
    private func setGoogleAd() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 812 * 50))
        googleAdView = GADBannerView(adSize: adSize)
        let adUnitID = Bundle.main.object(forInfoDictionaryKey: "GADSDKIdentifier") as? String
        googleAdView.adUnitID = adUnitID
        googleAdView.rootViewController = self
        googleAdView.load(GADRequest())
        googleAdView.delegate = self
        addBannerViewToView(googleAdView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: -14),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
       
    private func setDelegate() {
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
    }
    
    private func setRegister() {
        bannerCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.className)
    }
    
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.home
                           ])
    }
    
    private func openURL(link: URL) {
        if UIApplication.shared.canOpenURL(link) {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    private func bindActions() {
        giveCardView.rx.tapGesture()
            .when(.recognized) // bind시에도 이벤트가 발생하기 때문 .skip(1)으로도 처리 가능
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                owner.giveCardView.backgroundColor = .cardCreationClicked
                Analytics.logEvent(Tracking.Event.touchGiveCard, parameters: nil)
                print("명함 주기")
                owner.tabBarController?.selectedIndex = 1
            }.disposed(by: self.disposeBag)
        
        takeCardView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                owner.takeCardView.backgroundColor = .cardCreationClicked
                Analytics.logEvent(Tracking.Event.touchTakeCard, parameters: nil)
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
                Analytics.logEvent(Tracking.Event.touchAroundMe, parameters: nil)
                let aroundMeVC = self.moduleFactory.makeAroundMeVC()
                owner.present(aroundMeVC, animated: true)
            }.disposed(by: self.disposeBag)
        
        tryCardView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.makeVibrate()
                let cardcreationcategoryVC = self.moduleFactory.makeCardCreationCategoryVC()
                owner.navigationController?.pushViewController(cardcreationcategoryVC, animated: true)
            }.disposed(by: self.disposeBag)
    }
    
    private func checkUpdateVersionAndSetting() {
        updateUserInfoFetchWithAPI { [weak self] checkUpdateNote in
            if !checkUpdateNote {
                self?.updateNoteFetchWithAPI { updateNote in
                    if self?.checkUpdateAvailable(updateNote.latestVersion) ?? false {
                        self?.presentToUpdateVC(with: updateNote)
                        UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.dynamicLinkCardUUID)
                    } else {
                        if UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.openQRCodeWidget) {
                            self?.presentQRScanVC()
                        }
                        
                        if UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.openMyCardWidget),
                           let widgetCardUUID = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.widgetCardUUID) {
                            self?.presentCardShareBottomSheetVC(with: widgetCardUUID)
                        }
                        
                        if let dynamicLinkCardUUID = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.dynamicLinkCardUUID) {
                            self?.checkDynamicLink(dynamicLinkCardUUID)
                        }
                    }
                }
            } else {
                if UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.openQRCodeWidget) {
                    self?.presentQRScanVC()
                }
                
                if UserDefaults.standard.bool(forKey: Const.UserDefaultsKey.openMyCardWidget),
                   let widgetCardUUID = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.widgetCardUUID) {
                    self?.presentCardShareBottomSheetVC(with: widgetCardUUID)
                }
                
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
            self?.cardAddInGroupWithAPI(cardUUID: dynamicLinkCardUUID) {
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
                              completion: {
                UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.openQRCodeWidget)
            })
        case .authorized:
            guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true) {
                UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.openQRCodeWidget)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
                        nextVC.modalPresentationStyle = .overFullScreen
                        self.present(nextVC, animated: true) {
                            UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.openQRCodeWidget)
                        }
                    }
                }
            }
        default:
            break
        }
    }
    
    private func presentCardShareBottomSheetVC(with cardUUID: String) {
        if UserDefaults.appGroup.string(forKey: Const.UserDefaultsKey.accessToken) != nil {
            self.cardDetailFetchWithAPI(cardUUID: cardUUID) { [weak self] cardDataModel in
                let nextVC = CardShareBottomSheetViewController()
                    .setTitle("명함공유")
                    .setHeight(606.0)
                
                nextVC.isActivate = false
                nextVC.modalPresentationStyle = .overFullScreen
                nextVC.cardDataModel = cardDataModel
                
                self?.present(nextVC, animated: true) {
                    UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.openMyCardWidget)
                    UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.widgetCardUUID)
                }
            }
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(backToHome), name: .backToHome, object: nil)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func backToHome(_ notification: Notification) {
        setUI()
        setTracking()
    }
}

// MARK: - GADBannerViewDelegate

extension HomeViewController: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        googleAdView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 48
        let height: CGFloat = 40
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.className, for: indexPath) as? BannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        bannerCell.setData(banners[indexPath.row])
        return bannerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openURL(link: URL(string: banners[indexPath.row].url)!)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = UIScreen.main.bounds.width - 36
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        DispatchQueue.main.async {
            self.bannerPageLabel.text = "\(Int(index+1))/\(self.banners.count)"
        }
    }
}

// MARK: - Network
extension HomeViewController {
    private func bannerFetchWithAPI() {
        UpdateAPI.shared.bannerFetch { response in
            switch response {
            case .success(let data):
                guard let bannerInfo = data as? [BannerResponse] else { return }
                self.bannerPageLabel.text = "1/\(bannerInfo.count)"
                self.banners = bannerInfo
                self.bannerCollectionView.reloadData()
            case .requestErr(let message):
                print("bannerFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("bannerFetchWithAPI - pathErr")
            case .serverErr:
                print("bannerFetchWithAPI - serverErr")
            case .networkFail:
                print("bannerFetchWithAPI - networkFail")
            }
        }
    }
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
