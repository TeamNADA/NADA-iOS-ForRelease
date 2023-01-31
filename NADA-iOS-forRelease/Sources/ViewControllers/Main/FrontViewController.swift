//
//  FrontViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/02.
//

import UIKit

import KakaoSDKCommon
import NVActivityIndicatorView
import VerticalCardSwiper

class FrontViewController: UIViewController {
    
    // MARK: - Properteis
    
    private var offset = 0
    private var isInfiniteScroll = true
    private var cardDataList: [Card]? = []
    private var userID: String?
    
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
        
        setUserID()
        setDelegate()
        setNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isAfterCreation {
            DispatchQueue.main.async {
                
                self.setActivityIndicator()
                
                self.offset = 0
                self.cardDataList?.removeAll()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cardListFetchWithAPI(userID: self.userID, isList: false, offset: self.offset) {
                    _ = self.cardSwiper.scrollToCard(at: 0, animated: false)
                    self.activityIndicator.stopAnimating()
                    self.loadingBgView.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - @IBAction Properties
    // 명함 생성 뷰로 화면 전환
    @IBAction func presentToCardCreationView(_ sender: Any) {
        let nextVC = UIStoryboard(name: Const.Storyboard.Name.cardCreation, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardCreationViewController)
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // 명함 리스트 뷰로 화면 전환
    @IBAction func pushToCardListView(_ sender: Any) {
        let nextVC = UIStoryboard(name: Const.Storyboard.Name.cardList, bundle: nil).instantiateViewController(identifier: Const.ViewController.Identifier.cardListViewController)
    
        NotificationCenter.default.post(name: NSNotification.Name("deleteTabBar"), object: nil)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
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
    }
    
    private func setUserID() {
        userID = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID)
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
        offset = 0
        
        cardListFetchWithAPI(userID: userID, isList: false, offset: offset) {
            _ = self.cardSwiper.scrollToCard(at: 1, animated: false)
            self.isAfterCreation = false
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
                offset += 1
                guard let userID = userID else { return }
                cardListFetchWithAPI(userID: userID, isList: false, offset: offset) {
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
    func cardListFetchWithAPI(userID: String?, isList: Bool, offset: Int, completion: @escaping () -> Void = { }) {
        guard let userID = userID else { return }
        CardAPI.shared.cardListFetch(userID: userID, isList: isList, offset: offset) { response in
            switch response {
            case .success(let data):
                if let cardListLookUp = data as? CardListLookUp {
                    self.cardDataList?.append(contentsOf: cardListLookUp.cards)
                    self.cardSwiper.reloadData()
                }
                completion()
            case .requestErr(let message):
                print("cardListFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardListFetchWithAPI - pathErr")
            case .serverErr:
                print("cardListFetchWithAPI - serverErr")
            case .networkFail:
                print("cardListFetchWithAPI - networkFail")
            }
        }
    }
}
