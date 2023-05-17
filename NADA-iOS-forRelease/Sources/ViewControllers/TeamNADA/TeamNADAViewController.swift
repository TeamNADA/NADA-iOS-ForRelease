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
    var cardDataList: [Card]? = [Card(birth: "06월 07일",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "imgYun",
                                      cardName: "",
                                      cardTastes: [CardTasteInfo(cardTasteName: "읽씹", isChoose: false, sortOrder: 8),
                                                  CardTasteInfo(cardTasteName: "안읽씹", isChoose: true, sortOrder: 7),
                                                   CardTasteInfo(cardTasteName: "100% 1억", isChoose: true, sortOrder: 6),
                                                   CardTasteInfo(cardTasteName: "25% 100억", isChoose: false, sortOrder: 5),
                                                   CardTasteInfo(cardTasteName: "어떻게 죽을지", isChoose: false, sortOrder: 4),
                                                   CardTasteInfo(cardTasteName: "언제 죽을지 알기", isChoose: true, sortOrder: 3),
                                                   CardTasteInfo(cardTasteName: "모르는 게 약", isChoose: false, sortOrder: 2),
                                                   CardTasteInfo(cardTasteName: "아는 게 힘", isChoose: true, sortOrder: 1)],
                                      cardType: "BASIC",
                                      departmentName: "Project Manager",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: "ENTJ",
                                      phoneNumber: nil,
                                      instagram: "plright",
                                      twitter: "",
                                      tmi: "나의 TMI\n이래 봬도 월드 와이드 나다 PM 😗\n얘들아 고생했다 앞으로도 고생하자!\n그리고.. 행복하자....❤️‍🔥",
                                      urls: nil,
                                      userName: "박윤정"),
                                 // 이채연
                                 Card(birth: "01월 09일",
                                      cardID: 1,
                                      cardUUID: "",
                                      cardImage: "imgChae",
                                      cardName: "",
                                      cardTastes: [CardTasteInfo(cardTasteName: "읽씹", isChoose: true, sortOrder: 8),
                                                  CardTasteInfo(cardTasteName: "안읽씹", isChoose: false, sortOrder: 7),
                                                   CardTasteInfo(cardTasteName: "100% 1억", isChoose: true, sortOrder: 6),
                                                   CardTasteInfo(cardTasteName: "25% 100억", isChoose: false, sortOrder: 5),
                                                   CardTasteInfo(cardTasteName: "어떻게 죽을지", isChoose: false, sortOrder: 4),
                                                   CardTasteInfo(cardTasteName: "언제 죽을지 알기", isChoose: true, sortOrder: 3),
                                                   CardTasteInfo(cardTasteName: "모르는 게 약", isChoose: false, sortOrder: 2),
                                                   CardTasteInfo(cardTasteName: "아는 게 힘", isChoose: true, sortOrder: 1)],
                                      cardType: "BASIC",
                                      departmentName: "Designer",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: "INFJ",
                                      phoneNumber: nil,
                                      instagram: "chaens_",
                                      twitter: "",
                                      tmi: "🩷제가 바로 NADA 디자이너🩷",
                                      urls: nil,
                                      userName: "이채연"),
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
                                 Card(birth: "12월 17일",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "",
                                      cardName: "NADA",
                                      cardTastes: [CardTasteInfo(cardTasteName: "읽씹", isChoose: false, sortOrder: 8),
                                                  CardTasteInfo(cardTasteName: "안읽씹", isChoose: true, sortOrder: 7),
                                                   CardTasteInfo(cardTasteName: "100% 1억", isChoose: true, sortOrder: 6),
                                                   CardTasteInfo(cardTasteName: "25% 100억", isChoose: false, sortOrder: 5),
                                                   CardTasteInfo(cardTasteName: "어떻게 죽을지", isChoose: false, sortOrder: 4),
                                                   CardTasteInfo(cardTasteName: "언제 죽을지 알기", isChoose: true, sortOrder: 3),
                                                   CardTasteInfo(cardTasteName: "모르는 게 약", isChoose: false, sortOrder: 2),
                                                   CardTasteInfo(cardTasteName: "아는 게 힘", isChoose: true, sortOrder: 1)],
                                      cardType: "BASIC",
                                      departmentName: "Server Developer",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: "ESFP",
                                      phoneNumber: nil,
                                      instagram: "",
                                      twitter: "",
                                      tmi: nil,
                                      urls: nil,
                                      userName: "홍영준"),
                                 Card(birth: "04월 06일",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "imgYi",
                                      cardName: "NADA",
                                      cardTastes: [CardTasteInfo(cardTasteName: "읽씹", isChoose: false, sortOrder: 8),
                                                  CardTasteInfo(cardTasteName: "안읽씹", isChoose: true, sortOrder: 7),
                                                   CardTasteInfo(cardTasteName: "100% 1억", isChoose: true, sortOrder: 6),
                                                   CardTasteInfo(cardTasteName: "25% 100억", isChoose: false, sortOrder: 5),
                                                   CardTasteInfo(cardTasteName: "어떻게 죽을지", isChoose: true, sortOrder: 4),
                                                   CardTasteInfo(cardTasteName: "언제 죽을지 알기", isChoose: false, sortOrder: 3),
                                                   CardTasteInfo(cardTasteName: "모르는 게 약", isChoose: false, sortOrder: 2),
                                                   CardTasteInfo(cardTasteName: "아는 게 힘", isChoose: true, sortOrder: 1)],
                                      cardType: "BASIC",
                                      departmentName: "iOS Developer",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: "ISFJ",
                                      phoneNumber: nil,
                                      instagram: "dlwns33",
                                      twitter: "",
                                      tmi: nil,
                                      urls: ["https://github.com/dlwns33"],
                                      userName: "최이준"),
                                 Card(birth: "05월 02일",
                                      cardID: 0,
                                      cardUUID: "",
                                      cardImage: "imgHyun",
                                      cardName: "NADA",
                                      cardTastes: [CardTasteInfo(cardTasteName: "읽씹", isChoose: true, sortOrder: 8),
                                                  CardTasteInfo(cardTasteName: "안읽씹", isChoose: false, sortOrder: 7),
                                                   CardTasteInfo(cardTasteName: "100% 1억", isChoose: false, sortOrder: 6),
                                                   CardTasteInfo(cardTasteName: "25% 100억", isChoose: true, sortOrder: 5),
                                                   CardTasteInfo(cardTasteName: "어떻게 죽을지", isChoose: false, sortOrder: 4),
                                                   CardTasteInfo(cardTasteName: "언제 죽을지 알기", isChoose: true, sortOrder: 3),
                                                   CardTasteInfo(cardTasteName: "모르는 게 약", isChoose: false, sortOrder: 2),
                                                   CardTasteInfo(cardTasteName: "아는 게 힘", isChoose: true, sortOrder: 1)],
                                      cardType: "BASIC",
                                      departmentName: "iOS Developer",
                                      isRepresentative: false,
                                      mailAddress: nil,
                                      mbti: "ESFJ",
                                      phoneNumber: nil,
                                      instagram: "",
                                      twitter: "",
                                      tmi: nil,
                                      urls: ["https://github.com/hyun99999"],
                                      userName: "현규")]
    
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
