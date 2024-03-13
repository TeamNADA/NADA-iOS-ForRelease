//
//  AroundMeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/28.
//
import UIKit
import CoreLocation

import FirebaseAnalytics
import NVActivityIndicatorView
import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then

final class AroundMeViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: AroundMeViewModel!
    private let disposeBag = DisposeBag()
    var cardsNearBy: [AroundMeResponse] = []
    var locationManager = CLLocationManager()
    
    var didFindLocation = false
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    
    // MARK: - UI Components
    
    private let navigationBar = CustomNavigationBar().then {
        $0.backgroundColor = .background
    }
    private let emptyTitleLabel = UILabel().then {
        $0.text = "아직 근처에 명함이 없어요!"
        $0.font = .textBold02
        $0.textColor = .quaternary
        $0.sizeToFit()
    }
    private let emptyDescLabel = UILabel().then {
        $0.text = "명함 앞면 > 상단의 ‘공유' > 명함 활성화 버튼으로\n명함을 공유해 보세요."
        $0.numberOfLines = 2
        $0.font = .textRegular05
        $0.textColor = .quaternary
        $0.textAlignment = .center
    }
    private let emptyStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .vertical
        $0.alignment = .center
    }
    private let aroundMeCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    private lazy var aroundMeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: aroundMeCollectionViewFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.backgroundColor = .background
    }
    lazy var loadingBgView: UIView = {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        bgView.backgroundColor = .loadingBackground
        
        return bgView
    }()
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                        type: .ballBeat,
                                                        color: .mainColorNadaMain,
                                                        padding: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        setUI()
        setLayout()
        setDelegate()
        setRegister()
        bindActions()
        bindViewModels()
        setActivityIndicator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .backToHome, object: nil, userInfo: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
}

extension AroundMeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .background
        self.navigationController?.navigationBar.isHidden = true
        navigationBar.setUI("내 근처의 명함", leftImage: UIImage(named: "iconClear"), rightImage: UIImage(named: "iconRefreshLocation"))
        navigationBar.leftButtonAction = {
            Analytics.logEvent(Tracking.Event.touchAroundMeClose, parameters: nil)
            self.dismiss(animated: true)
        }
        navigationBar.rightButtonAction = {
            print("리프레시")
        }
    }
    
    private func setLayout() {
        view.addSubviews([navigationBar, emptyStackView, aroundMeCollectionView])
        emptyStackView.addArrangedSubviews([emptyTitleLabel, emptyDescLabel])
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        emptyStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(57)
        }
        aroundMeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Methods
    
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.aroundMe
                           ])
    }
    
    private func setActivityIndicator() {
        view.addSubview(loadingBgView)
        loadingBgView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        getLocationUsagePermission()
    }
    
    private func setDelegate() {
        aroundMeCollectionView.dataSource = self
        aroundMeCollectionView.delegate = self
    }
    
    private func setRegister() {
        aroundMeCollectionView.register(AroundMeCollectionViewCell.self, forCellWithReuseIdentifier: AroundMeCollectionViewCell.className)
    }
    
    func setData(cardList: [AroundMeResponse]) {
        self.cardsNearBy = cardList
        self.aroundMeCollectionView.reloadData()
    }
    
    private func bindActions() {
        navigationBar.rightButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.makeVibrate(degree: .medium)
                owner.setActivityIndicator()
                Analytics.logEvent(Tracking.Event.touchAroundMeRefresh, parameters: nil)
                owner.cardNearByFetchWithAPI(longitude: self.longitude, latitude: self.latitude)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindViewModels() {
        let input = AroundMeViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in
                self.cardNearByFetchWithAPI(longitude: self.longitude, latitude: self.latitude)
            },
            refreshButtonTapEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in})
        let output = self.viewModel.transform(input: input)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AroundMeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 48
        let height: CGFloat = 144
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension AroundMeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsNearBy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: AroundMeCollectionViewCell.className, for: indexPath) as? AroundMeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cardCell.setData(cardsNearBy[indexPath.row])
        cardCell.addCardMethod = { [weak self] in
            let index = indexPath.row
            print("\(index) Call Back Method")
            Analytics.logEvent(Tracking.Event.touchAroundMeAdd, parameters: [
                "내근처의명함_추가_asn": indexPath.row + 1
               ])
            // 여기서 카드 추가 API
            self?.cardDetailFetchWithAPI(cardUUID: self?.cardsNearBy[indexPath.row].cardUUID ?? "")
        }
        return cardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}

// MARK: - CLLocationManagerDelegate

extension AroundMeViewController: CLLocationManagerDelegate {
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("✅ 위도: ", location.coordinate.latitude)
            print("✅ 경도: ", location.coordinate.longitude)
            
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            if !didFindLocation {
                cardNearByFetchWithAPI(longitude: longitude, latitude: latitude)
                didFindLocation = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         // location5
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             print("GPS 권한 설정됨")
             self.locationManager.startUpdatingLocation() // 중요!
         case .restricted, .notDetermined:
             print("GPS 권한 설정되지 않음")
             getLocationUsagePermission()
         case .denied:
             print("GPS 권한 요청 거부됨")
             getLocationUsagePermission()
         default:
             print("GPS: Default")
         }
     }
}

// MARK: - Network

extension AroundMeViewController {
    func cardNearByFetchWithAPI(longitude: Double, latitude: Double) {
        NearbyAPI.shared.cardNearByFetch(longitde: longitude, latitude: latitude) { response in
            switch response {
            case .success(let data):
                self.activityIndicator.stopAnimating()
                self.loadingBgView.removeFromSuperview()
                if let cards = data as? [AroundMeResponse] {
                    self.cardsNearBy = cards
                    print(cards)
                    if cards.isEmpty {
                        self.aroundMeCollectionView.isHidden = true
                    } else {
                        self.aroundMeCollectionView.isHidden = false
                    }
                    self.aroundMeCollectionView.reloadData()
                }
                print("cardNearByFetchWithAPI - success")
            case .requestErr(let message):
                print("cardNearByFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardNearByFetchWithAPI - pathErr")
            case .serverErr:
                print("cardNearByFetchWithAPI - serverErr")
            case .networkFail:
                print("cardNearByFetchWithAPI - networkFail")
            }
        }
    }
    
    func cardDetailFetchWithAPI(cardUUID: String) {
        CardAPI.shared.cardDetailFetch(cardUUID: cardUUID) { response in
            switch response {
            case .success(let data):
                if let card = data as? Card {
                    // TODO: - 자신의 명함 추가하는 경우 예외처리.
                    //                    if UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) == card.author {
                    //                        self.errorImageView.isHidden = false
                    //                        self.explainLabel.isHidden = false
                    //                        self.explainLabel.text = "자신의 명함은 추가할 수 없습니다."
                    //                    } else {
                    let nextVC = CardResultBottomSheetViewController()
                                .setTitle(card.userName)
                                .setHeight(574)
                    nextVC.cardDataModel = card
                    nextVC.modalPresentationStyle = .overFullScreen
                    self.present(nextVC, animated: false, completion: nil)
                }
            case .requestErr(let message):
                print("cardDetailFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardDetailFetchWithAPI - pathErr")
            case .serverErr:
                print("cardDetailFetchWithAPI - serverErr")
            case .networkFail:
                print("cardDetailFetchWithAPI - networkFail")
            }
        }
    }
}
