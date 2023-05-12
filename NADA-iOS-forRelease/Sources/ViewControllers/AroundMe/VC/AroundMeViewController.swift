//
//  AroundMeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/28.
//
import UIKit
import CoreLocation

import UIKit

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
    }
    
}

extension AroundMeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .background
        self.navigationController?.navigationBar.isHidden = true
        navigationBar.setUI("내 근처의 명함", leftImage: UIImage(named: "iconClear"), rightImage: UIImage(named: "iconRefreshLocation"))
        navigationBar.leftButtonAction = {
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
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("✅ 위도: ", location.coordinate.latitude)
            print("✅ 경도: ", location.coordinate.longitude)
            
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            cardNearByFetchWithAPI(longitude: longitude, latitude: latitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - Network

extension AroundMeViewController {
    func cardNearByFetchWithAPI(longitude: Double, latitude: Double) {
        NearbyAPI.shared.cardNearByFetch(longitde: longitude, latitude: latitude) { response in
            switch response {
            case .success(let data):
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
