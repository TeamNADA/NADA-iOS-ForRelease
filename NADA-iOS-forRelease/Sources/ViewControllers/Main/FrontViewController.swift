//
//  FrontViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/02.
//

import UIKit
import VerticalCardSwiper
import KakaoSDKCommon

class FrontViewController: UIViewController {
    
    // MARK: - Properteis
    var cardDataList: [Card] = []
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        setNotification()
        // TODO: - 서버 테스트
        
//        cardListFetchWithAPI(userID: "nada", isList: false, offset: 0)
    }
    
    // FIXME: - qa테스트
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nextVC = FirstCardAlertBottomSheetViewController()
            .setTitle("""
                      🎉
                      첫 명함이 생성되었어요!
                      """)
            .setHeight(587)
        nextVC.modalPresentationStyle = .overFullScreen
        present(nextVC, animated: true, completion: nil)
        setMain()
    }
    
    // MARK: - @IBAction Properties
    // 명함 생성 뷰로 화면 전환
    @IBAction func presentToCardCreationView(_ sender: Any) {
        let nextVC = UIStoryboard(name: Const.Storyboard.Name.cardCreation, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardCreationViewController)
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalPresentationStyle = .overFullScreen
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
    
    private func setMain() {
        if let userID = UserDefaults.standard.string(forKey: Const.UserDefaults.userID) {
            cardListFetchWithAPI(userID: "nada2", isList: false, offset: 0)
        }
    }
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecievePresentCardShare(_:)), name: Notification.Name.presentCardShare, object: nil)
    }
    
    @objc func didRecievePresentCardShare(_ notification: Notification) {
        let nextVC = CardShareBottomSheetViewController()
            .setTitle("명함공유")
            .setHeight(404)
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
}

// MARK: - VerticalCardSwiperDelegate
extension FrontViewController: VerticalCardSwiperDelegate {
    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        return CGSize(width: 375, height: 630)
    }
}

// MARK: - VerticalCardSwiperDatasource
extension FrontViewController: VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        let count = cardDataList.count
        return count == 0 ? 1 : count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if cardDataList.count != 0 {
            guard let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: Const.Xib.mainCardCell, for: index) as? MainCardCell else { return CardCell() }
            let cardDataList = cardDataList
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
    func cardListFetchWithAPI(userID: String, isList: Bool, offset: Int) {
        CardAPI.shared.cardListFetch(userID: userID, isList: isList, offset: offset) { response in
            switch response {
            case .success(let data):
                if let card = data as? CardListLookUpRequest {
                    print(card.cards, "⭐️")
                    self.cardDataList = card.cards
                    self.cardSwiper.reloadData()
                }
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
