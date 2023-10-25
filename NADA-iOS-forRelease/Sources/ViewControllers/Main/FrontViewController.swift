//
//  FrontViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/02.
//

import UIKit

import FirebaseAnalytics
import KakaoSDKCommon
import NVActivityIndicatorView
import VerticalCardSwiper

class FrontViewController: UIViewController {
    
    // MARK: - Properteis
    
    private var isInfiniteScroll = true
    private var cardDataList: [Card]? = []
    private var pageNumber: Int = 1
    private let pageSize: Int = 8
    
    var isAfterCreation = false
    
    // MARK: - Components
    
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
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isAfterCreation {
            DispatchQueue.main.async {
                
                self.setActivityIndicator()
                
                self.pageNumber = 1
                self.cardDataList?.removeAll()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.cardListPageFetchWithAPI(pageNumber: self?.pageNumber ?? -1, pageSize: self?.pageSize ?? -1) {
                    _ = self?.cardSwiper.scrollToCard(at: 0, animated: false)
                    self?.activityIndicator.stopAnimating()
                    self?.loadingBgView.removeFromSuperview()
                }
            }
        }
        self.isAfterCreation = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
    
    // MARK: - @IBAction Properties
    // 명함 생성 뷰로 화면 전환
    @IBAction func presentToCardCreationCategoryViewController(_ sender: Any) {
        let nextVC = CardCreationCategoryViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        Analytics.logEvent(Tracking.Event.touchCreateCard, parameters: nil)
    }
    
    // 명함 리스트 뷰로 화면 전환
    @IBAction func pushToCardListView(_ sender: Any) {
        let nextVC = UIStoryboard(name: Const.Storyboard.Name.cardList, bundle: nil).instantiateViewController(identifier: Const.ViewController.Identifier.cardListViewController)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        Analytics.logEvent(Tracking.Event.touchCardList, parameters: nil)
    }
}

// MARK: - Extensions
extension FrontViewController {    
    private func setDelegate() {
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        
        cardSwiper.isSideSwipingEnabled = false
        
        cardSwiper.register(nib: MainCardCell.nib(), forCellWithReuseIdentifier: Const.Xib.mainCardCell)
        cardSwiper.register(nib: EmptyCardCell.nib(), forCellWithReuseIdentifier: Const.Xib.emptyCardCell)
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecievePresentCardShare(_:)), name: .presentCardShare, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setCreationReloadMainCardSwiper), name: .creationReloadMainCardSwiper, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentToTagSheet(_:)), name: .presentToTagSheet, object: nil)
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
    
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.myCard
                           ])
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func didRecievePresentCardShare(_ notification: Notification) {
        let nextVC = CardShareBottomSheetViewController()
            .setTitle("명함공유")
            .setHeight(606.0)

        if let cardData = notification.object as? Card {
            nextVC.cardDataModel = cardData
        }
        
        // FIXME: - 명함 공유 활성화여부 넘기기(서버 혹은 multipeer connectivity 로)
        nextVC.isActivate = false
        
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    
    @objc
    private func setCreationReloadMainCardSwiper() {
        isAfterCreation = true
        
        cardDataList?.removeAll()
        pageNumber = 1
        
        cardListPageFetchWithAPI(pageNumber: pageNumber, pageSize: pageSize) {
            _ = self.cardSwiper.scrollToCard(at: 1, animated: false)
        }
    }
    
    @objc
    private func presentToTagSheet(_ notification: Notification) {
        if let cardUUID = notification.object as? String {
            let tagSheet = FetchTagSheetVC()
            
            if #available(iOS 16.0, *) {
                
                if let sheet = tagSheet.sheetPresentationController {
                    sheet.detents = [CustomDetent.receivedTagDetent, .large()]
                    sheet.preferredCornerRadius = 30
                }
            } else {
                if let sheet = tagSheet.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.preferredCornerRadius = 30
                }
            }
            tagSheet.setCardUUID(cardUUID)
            tagSheet.modalPresentationStyle = .pageSheet
            
            present(tagSheet, animated: true)
        }
    }
}

// MARK: - VerticalCardSwiperDelegate
extension FrontViewController: VerticalCardSwiperDelegate {
    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        return CGSize(width: 375, height: 630)
    }
    
    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        if verticalCardSwiperView.contentOffset.y > verticalCardSwiperView.contentSize.height - verticalCardSwiperView.bounds.height {
            if isInfiniteScroll {
                isInfiniteScroll = false
                pageNumber += 1

                cardListPageFetchWithAPI(pageNumber: pageNumber, pageSize: pageSize) {
                    self.isInfiniteScroll = true
                }
            }
        }
    }
}

// MARK: - VerticalCardSwiperDatasource
extension FrontViewController: VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        guard let cardDataList = cardDataList else { return 0 }
        let count = cardDataList.count
        return count == 0 ? 1 : count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if cardDataList?.count != 0 {
            guard let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: Const.Xib.mainCardCell, for: index) as? MainCardCell else { return CardCell() }
            guard let cardDataList = cardDataList else { return CardCell() }
            UserDefaults.standard.set(cardDataList[0].cardID, forKey: Const.UserDefaultsKey.firstCardID)
            cell.initCell(cardDataModel: cardDataList[index])
            cell.isShareable = true
            cell.cardType = CardType(rawValue: cardDataList[index].cardType)
            cell.cardContext = .myCard
            cell.setFrontCard()
            
            return cell
        } else {
            guard let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: Const.Xib.emptyCardCell, for: index) as? EmptyCardCell else { return CardCell() }
            return cell
        }
    }
    
}

// MARK: - Network
extension FrontViewController {
    func cardListPageFetchWithAPI(pageNumber: Int, pageSize: Int, completion: @escaping () -> Void = { }) {
        CardAPI.shared.cardListFetch(pageNumber: pageNumber, pageSize: pageSize) { response in
            switch response {
            case .success(let data):
                if let cardData = data as? [Card] {
                    self.cardDataList?.append(contentsOf: cardData)
                    self.cardSwiper.reloadData()
                    
                    if !cardData.isEmpty {
                        Analytics.logEvent(Tracking.Event.scrollMyCard + String(pageNumber), parameters: nil)
                    }
                }
                completion()
            case .requestErr(let message):
                print("cardListPageFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardListPageFetchWithAPI - pathErr")
            case .serverErr:
                print("cardListPageFetchWithAPI - serverErr")
            case .networkFail:
                print("cardListPageFetchWithAPI - networkFail")
            }
        }
    }
}
