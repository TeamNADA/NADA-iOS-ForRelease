//
//  TeamNADAViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/11.
//

import UIKit
import VerticalCardSwiper

class TeamNADAViewController: UIViewController {
    
    // MARK: - Properteis
    var cardDataList: [Card]? = [Card(birth: "",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "",
                                      cardName: "",
                                      cardTastes: [],
                                      cardType: "",
                                      departmentName: "",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: nil,
                                      phoneNumber: nil,
                                      instagram: "",
                                      twitter: "",
                                      tmi: nil,
                                      urls: nil,
                                      userName: ""),
                                 Card(birth: "",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "",
                                      cardName: "",
                                      cardTastes: [],
                                      cardType: "",
                                      departmentName: "",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: nil,
                                      phoneNumber: nil,
                                      instagram: "",
                                      twitter: "",
                                      tmi: nil,
                                      urls: nil,
                                      userName: ""),
                                 Card(birth: "",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "",
                                      cardName: "",
                                      cardTastes: [],
                                      cardType: "",
                                      departmentName: "",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: nil,
                                      phoneNumber: nil,
                                      instagram: "",
                                      twitter: "",
                                      tmi: nil,
                                      urls: nil,
                                      userName: ""),
                                 Card(birth: "",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "",
                                      cardName: "",
                                      cardTastes: [],
                                      cardType: "",
                                      departmentName: "",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: nil,
                                      phoneNumber: nil,
                                      instagram: "",
                                      twitter: "",
                                      tmi: nil,
                                      urls: nil,
                                      userName: ""),
                                 Card(birth: "",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "",
                                      cardName: "",
                                      cardTastes: [],
                                      cardType: "",
                                      departmentName: "",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: nil,
                                      phoneNumber: nil,
                                      instagram: "",
                                      twitter: "",
                                      tmi: nil,
                                      urls: nil,
                                      userName: ""),
                                 Card(birth: "",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "",
                                      cardName: "",
                                      cardTastes: [],
                                      cardType: "",
                                      departmentName: "",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: nil,
                                      phoneNumber: nil,
                                      instagram: "",
                                      twitter: "",
                                      tmi: nil,
                                      urls: nil,
                                      userName: "")]
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBackSwipeMotion()
        setDelegate()
    }
    
    // MARK: - @IBAction Properties
    @IBAction func dismissToPreviousView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extensions
extension TeamNADAViewController {
    func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setDelegate() {
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        
        cardSwiper.isSideSwipingEnabled = false
        
        cardSwiper.register(nib: MainCardCell.nib(), forCellWithReuseIdentifier: Const.Xib.mainCardCell)
    }
}

// MARK: - VerticalCardSwiperDelegate
extension TeamNADAViewController: VerticalCardSwiperDelegate {
    func sizeForItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) -> CGSize {
        return CGSize(width: 375, height: 630)
    }
}

// MARK: - VerticalCardSwiperDatasource
extension TeamNADAViewController: VerticalCardSwiperDatasource {
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return cardDataList?.count ?? 0
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        guard let cell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: Const.Xib.mainCardCell, for: index) as? MainCardCell else { return CardCell() }
        guard let cardDataList = cardDataList else { return CardCell() }
        cell.initCell(cardDataModel: cardDataList[index])
        cell.isShareable = false
        cell.setFrontCard()
        
        return cell
    }
}
