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
    // 앞면
    private var imageList = [String]()
    private var cardNameList = [String]()
    private var detailCardNameList = [String]()
    private var userNameList = [String]()
    private var birthList = [String]()
    private var mbtiList = [String]()
    private var instagramIDList = [String]()
    private var linkImageList = [String]()
    private var linkTextList = [String]()
    private var linkIDList = [String]()
    
    // 뒷면
    private var mintImageList = [Bool]()
    private var noMintImageList = [Bool]()
    private var sojuImageList = [Bool]()
    private var beerImageList = [Bool]()
    private var pourImageList = [Bool]()
    private var putSauceImageList = [Bool]()
    private var yangnyumImageList = [Bool]()
    private var friedImageList = [Bool]()
    private var firstTmiList = [String]()
    private var secondTmiList = [String]()
    private var thirdTmiLabel = [String]()
    
    var isFrontCard: [Bool] = [true, true]
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setFrontList()
        setBackList()
        // TODO: - 서버 테스트
//        cardListFetchWithAPI(userID: "nada", isList: false, offset: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("expressTabBar"), object: nil)
        
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
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        
        cardSwiper.isSideSwipingEnabled = false
        
        cardSwiper.register(nib: UINib(nibName: Const.Xib.frontCardCell, bundle: nil), forCellWithReuseIdentifier: Const.Xib.frontCardCell)
        cardSwiper.register(nib: UINib(nibName: Const.Xib.backCardCell, bundle: nil), forCellWithReuseIdentifier: Const.Xib.backCardCell)
    }
    
    private func setFrontList() {
        imageList.append(contentsOf: ["card",
                                      "card"
                                     ])
        cardNameList.append(contentsOf: ["SOPT 명함",
                                         "SOPT 명함"
                                        ])
        detailCardNameList.append(contentsOf: ["29기 디자인파트",
                                               "29기 디자인파트"
                                              ])
        userNameList.append(contentsOf: ["이채연",
                                         "이채연"
                                        ])
        birthList.append(contentsOf: ["1998.01.09 (24)",
                                      "1998.01.09 (24)"
                                     ])
        mbtiList.append(contentsOf: ["ENFP",
                                     "ENFP"
                                    ])
        instagramIDList.append(contentsOf: ["chaens_",
                                            "chaens_"
                                           ])
        linkImageList.append(contentsOf: ["testLink",
                                          "testLink"
                                         ])
        linkTextList.append(contentsOf: ["Blog",
                                         "Blog"
                                        ])
        linkIDList.append(contentsOf: ["https://github.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADAgithub.com/TeamNADA",
                                       "https://github.com/TeamNADA"
                                      ])
    }
    
    private func setBackList() {
        mintImageList.append(contentsOf: [true,
                                          false
                                         ])
        noMintImageList.append(contentsOf: [false,
                                            true
                                           ])
        sojuImageList.append(contentsOf: [true,
                                          false
                                         ])
        beerImageList.append(contentsOf: [false,
                                          true
                                         ])
        pourImageList.append(contentsOf: [false,
                                          true
                                         ])
        putSauceImageList.append(contentsOf: [true,
                                              false
                                             ])
        yangnyumImageList.append(contentsOf: [false,
                                              true
                                             ])
        friedImageList.append(contentsOf: [true,
                                           false
                                          ])
        firstTmiList.append(contentsOf: ["첫번째",
                                         "첫번째"
                                        ])
        secondTmiList.append(contentsOf: ["두번째리따리따",
                                         "두번째"
                                        ])
        thirdTmiLabel.append(contentsOf: ["세번째리따라라ㅏㄹ",
                                         "세번째"
                                        ])
    }
}

// MARK: - VerticalCardSwiperDelegate
extension FrontViewController: VerticalCardSwiperDelegate {
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        let frontCell = cardSwiper.cardForItem(at: index)
        let backCell = cardSwiper.cardForItem(at: index)
        if isFrontCard[index] {
            isFrontCard[index] = false
            UIView.transition(with: frontCell ?? CardCell(), duration: 0.5, options: .transitionFlipFromLeft, animations: nil) {_ in
                self.cardSwiper.reloadData()
            }
        } else {
            isFrontCard[index] = true
            UIView.transition(with: backCell ?? CardCell(), duration: 0.5, options: .transitionFlipFromRight, animations: nil) {_ in
                self.cardSwiper.reloadData()
            }
        }
    }
}

// MARK: - VerticalCardSwiperDatasource
extension FrontViewController: VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return imageList.count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if isFrontCard[index] {
            guard let frontCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "FrontCardCell", for: index) as? FrontCardCell else {
                return CardCell()
            }
            frontCell.initCell(imageList[index], cardNameList[index], detailCardNameList[index], userNameList[index], birthList[index], mbtiList[index], instagramIDList[index], linkIDList[index])
            return frontCell
        } else {
            guard let backCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "BackCardCell", for: index) as? BackCardCell else {
                return CardCell()
            }
            backCell.initCell(imageList[index],
                              mintImageList[index],
                              sojuImageList[index],
                              pourImageList[index],
                              yangnyumImageList[index],
                              firstTmiList[index],
                              secondTmiList[index],
                              thirdTmiLabel[index])
            return backCell
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
