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

    var cardDataList: [Card]? = [Card(cardID: "card",
                                      background: "card",
                                      title: "SOPT 명함",
                                      name: "이채연",
                                      birthDate: "1998.01.09 (24)",
                                      mbti: "ENFP",
                                      instagram: "chaens_",
                                      link: "https://github.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADA",
                                      cardDescription: "29기 디자인파트",
                                      isMincho: true,
                                      isSoju: true,
                                      isBoomuk: true,
                                      isSauced: true,
                                      oneTmi: "첫번째",
                                      twoTmi: "두번째",
                                      threeTmi: "세번째세번째세번째"),
                                 Card(cardID: "card",
                                      background: "card",
                                      title: "SOPT 명함",
                                      name: "이채연",
                                      birthDate: "1998.01.09 (24)",
                                      mbti: "ENFP",
                                      instagram: "minimin.0_0",
                                      link: "https://www.naver.com",
                                      cardDescription: "29기 디자인파트",
                                      isMincho: true,
                                      isSoju: true,
                                      isBoomuk: true,
                                      isSauced: true,
                                      oneTmi: "첫번째",
                                      twoTmi: "두번째",
                                      threeTmi: "세번째세번째세번째")]
    
    // var cardDataList: [Card]? = []
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setCardDataModelList()
        setDelegate()
        // TODO: - 서버 테스트
//        cardListFetchWithAPI(userID: "nada", isList: false, offset: 0)
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
    private func setUI() {
        
    }
    private func setDelegate() {
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        
        cardSwiper.isSideSwipingEnabled = false
        
        cardSwiper.register(nib: MainCardCell.nib(), forCellWithReuseIdentifier: Const.Xib.mainCardCell)
        cardSwiper.register(nib: EmptyCardCell.nib(), forCellWithReuseIdentifier: Const.Xib.emptyCardCell)
    }
    
//    private func setCardDataModelList() {
//        cardDataList?.append(contentsOf: [
//            Card(cardID: "card",
//                 background: "card",
//                 title: "SOPT 명함",
//                 name: "이채연",
//                 birthDate: "1998.01.09 (24)",
//                 mbti: "ENFP",
//                 instagram: "chaens_",
//                 link: "https://github.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADA",
//                 cardDescription: "29기 디자인파트",
//                 isMincho: true,
//                 isSoju: true,
//                 isBoomuk: true,
//                 isSauced: true,
//                 oneTMI: "첫번째",
//                 twoTMI: "두번째",
//                 thirdTMI: "세번째세번째세번째"),
//            Card(cardID: "card",
//                 background: "card",
//                 title: "SOPT 명함",
//                 name: "이채연",
//                 birthDate: "1998.01.09 (24)",
//                 mbti: "ENFP",
//                 instagram: "minimin.0_0",
//                 link: "https://www.naver.com",
//                 cardDescription: "29기 디자인파트",
//                 isMincho: true,
//                 isSoju: true,
//                 isBoomuk: true,
//                 isSauced: true,
//                 oneTMI: "첫번째",
//                 twoTMI: "두번째",
//                 thirdTMI: "세번째세번째세번째")
//        ])
//    }
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
        guard let count = cardDataList?.count else { return 0 }
        return count == 0 ? 1 : count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if cardDataList?.count != 0 {
            guard let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: Const.Xib.mainCardCell, for: index) as? MainCardCell else { return CardCell() }
            guard let cardDataList = cardDataList else { return CardCell() }
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
                if let card = data as? CardListRequest {
                    print(card)
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
