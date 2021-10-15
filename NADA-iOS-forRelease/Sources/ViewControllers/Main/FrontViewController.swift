//
//  FrontViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/02.
//

import UIKit
import VerticalCardSwiper

class FrontViewController: UIViewController {
    
    // MARK: - Properteis
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
    
    private var mintImageList = [String]()
    private var noMintImageList = [String]()
    private var sojuImageList = [String]()
    private var beerImageList = [String]()
    private var pourImageList = [String]()
    private var putSauceImageList = [String]()
    private var yangnyumImageList = [String]()
    private var friedImageList = [String]()
    private var firstQuestionList = [String]()
    private var firstAnswerList = [String]()
    private var secondQuestionList = [String]()
    private var secondAnswerList = [String]()
    
    var isFrontCard: [Bool] = [true, true]
    
    // MARK: - @IBOutlet
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        
        cardSwiper.isSideSwipingEnabled = false
        
        cardSwiper.register(nib: UINib(nibName: "FrontCardCell", bundle: nil), forCellWithReuseIdentifier: "FrontCardCell")
        cardSwiper.register(nib: UINib(nibName: "BackCardCell", bundle: nil), forCellWithReuseIdentifier: "BackCardCell")
        
        setFrontList()
        setBackList()
        
    }
    
    // MARK: - @IBAction
    // 명함 리스트 뷰로 화면 전환
    @IBAction func pushToCardListView(_ sender: Any) {
        guard let nextVC = UIStoryboard(name: "CardList", bundle: nil).instantiateViewController(identifier: "CardListViewController") as? CardListViewController else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 명함 생성 뷰로 화면 전환
    @IBAction func presentToCardCreationView(_ sender: Any) {
        let stortboard = UIStoryboard(name: "CardCreation", bundle: nil)

        if let nextVC = stortboard.instantiateViewController(identifier: "CardCreationViewController") as? CardCreationViewController {
                nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Extension
extension FrontViewController {
    private func setFrontList() {
        imageList.append(contentsOf: ["bg1",
                                      "bg1"
                                     ])
        cardNameList.append(contentsOf: ["SOPT 28기 명함",
                                         "SOPT 28기 명함"
                                        ])
        detailCardNameList.append(contentsOf: ["28기 디자인파트원",
                                               "28기 디자인파트원"
                                              ])
        userNameList.append(contentsOf: ["김태양",
                                         "김태양"
                                        ])
        birthList.append(contentsOf: ["2002/11/06 (20세)",
                                      "2002/11/06 (20세)"
                                     ])
        mbtiList.append(contentsOf: ["ISTJ",
                                     "ISTJ"
                                    ])
        instagramIDList.append(contentsOf: ["@passio84ever",
                                            "@passio84ever"
                                           ])
        linkImageList.append(contentsOf: ["testLink",
                                          "testLink"
                                         ])
        linkTextList.append(contentsOf: ["Blog",
                                         "Blog"
                                        ])
        linkIDList.append(contentsOf: ["blog.naver.com/\npark_yunjung",
                                       "blog.naver.com/\npark_yunjung"
                                      ])
    }
    
    private func setBackList() {
        mintImageList.append(contentsOf: ["opt1Select",
                                          "opt1Select"
                                         ])
        noMintImageList.append(contentsOf: ["opt2Unselect",
                                            "opt2Unselect"
                                           ])
        sojuImageList.append(contentsOf: ["opt3Unselect",
                                          "opt3Unselect"
                                         ])
        beerImageList.append(contentsOf: ["opt4Select",
                                          "opt4Select"
                                         ])
        pourImageList.append(contentsOf: ["opt5Unselect",
                                          "opt5Unselect"
                                         ])
        putSauceImageList.append(contentsOf: ["opt6Select",
                                              "opt6Select"
                                             ])
        yangnyumImageList.append(contentsOf: ["opt7Select",
                                              "opt7Select"
                                             ])
        friedImageList.append(contentsOf: ["opt8Unselect",
                                           "opt8Unselect"
                                          ])
        firstQuestionList.append(contentsOf: ["Q1. 직접 질문 추가",
                                              ""
                                             ])
        firstAnswerList.append(contentsOf: ["질문에 대한 대답입니다.",
                                            ""
                                           ])
        secondQuestionList.append(contentsOf: ["Q2. 직접 질문 추가",
                                               ""
                                              ])
        secondAnswerList.append(contentsOf: ["질문에 대한 대답입니다.",
                                             ""
                                            ])
    }
}

// VerticalCardSwiperDelegate
extension FrontViewController: VerticalCardSwiperDelegate {
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        let frontCell = cardSwiper.cardForItem(at: index)
        let backCell = cardSwiper.cardForItem(at: index)
        if isFrontCard[index] {
            isFrontCard[index] = false
            UIView.transition(with: frontCell ?? CardCell(), duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: {_ in
                self.cardSwiper.reloadData()
            })
        } else {
            isFrontCard[index] = true
            UIView.transition(with: backCell ?? CardCell(), duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: {_ in
                self.cardSwiper.reloadData()
            })
        }
    }
}

// VerticalCardSwiperDatasource
extension FrontViewController: VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return imageList.count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if isFrontCard[index] {
            guard let frontCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "FrontCardCell", for: index) as? FrontCardCell else {
                return CardCell()
            }
            frontCell.initCell(imageList[index], cardNameList[index], detailCardNameList[index], userNameList[index], birthList[index], mbtiList[index], instagramIDList[index], linkImageList[index], linkTextList[index], linkIDList[index])
            return frontCell
        } else {
            guard let backCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "BackCardCell", for: index) as? BackCardCell else {
                return CardCell()
            }
            backCell.initCell(imageList[index], mintImageList[index], noMintImageList[index], sojuImageList[index], beerImageList[index], pourImageList[index], putSauceImageList[index], yangnyumImageList[index], friedImageList[index], firstQuestionList[index], firstAnswerList[index], secondQuestionList[index], secondAnswerList[index])
            return backCell
        }
    }
}
