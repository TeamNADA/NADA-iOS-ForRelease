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
    
    // MARK: - @IBOutlet
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cardSwiper.delegate = self
        cardSwiper.datasource = self
        
        cardSwiper.isSideSwipingEnabled = false
        
        cardSwiper.register(nib: UINib(nibName: "FrontCardCell", bundle: nil), forCellWithReuseIdentifier: "FrontCardCell")
        
        setList()
    }
    
    // MARK: - @IBAction
    // 명함 리스트 뷰로 화면 전환
    @IBAction func pushToCardListView(_ sender: Any) {
    }
    
    // 명함 생성 뷰로 화면 전환
    @IBAction func presentToCardCreationView(_ sender: Any) {
    }
}

// MARK: - Extension
extension FrontViewController {
    private func setList() {
        imageList.append(contentsOf: [ "testBg",
                                       "testBg"
                                     ])
        cardNameList.append(contentsOf: [ "SOPT 28기 명함",
                                          "SOPT 28기 명함"
                                        ])
        detailCardNameList.append(contentsOf: [ "28기 디자인파트원",
                                                "28기 디자인파트원"
                                              ])
        userNameList.append(contentsOf: ["김태양",
                                         "김태양"
                                        ])
        birthList.append(contentsOf: [ "2002/11/06 (20세)",
                                       "2002/11/06 (20세)"
                                     ])
        mbtiList.append(contentsOf: [ "ISTJ",
                                      "ISTJ"
                                    ])
        instagramIDList.append(contentsOf: [ "@passio84ever",
                                             "@passio84ever"
                                           ])
        linkImageList.append(contentsOf: [ "testLink",
                                           "testLink"
                                         ])
        linkTextList.append(contentsOf: [ "Blog",
                                          "Blog"
                                        ])
        linkIDList.append(contentsOf: [ "blog.naver.com/\npark_yunjung",
                                        "blog.naver.com/\npark_yunjung"
                                      ])
    }
}

// VerticalCardSwiperDelegate
extension FrontViewController: VerticalCardSwiperDelegate {
    
}

// VerticalCardSwiperDatasource
extension FrontViewController: VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return imageList.count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        guard let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "FrontCardCell", for: index) as? FrontCardCell else {
            return CardCell()
        }
        cell.initCell(imageList[index], cardNameList[index], detailCardNameList[index], userNameList[index], birthList[index], mbtiList[index], instagramIDList[index], linkImageList[index], linkTextList[index], linkIDList[index])
        
        return cell
    }
}
