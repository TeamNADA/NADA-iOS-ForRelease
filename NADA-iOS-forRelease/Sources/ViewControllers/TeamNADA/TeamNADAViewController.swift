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
    var cardDataList: [Card]? = [Card(cardID: "card",
                                      background: "imgYun",
                                      title: "NADA",
                                      name: "박윤정",
                                      birthDate: "1998.06.07 (24)",
                                      mbti: "ENTJ",
                                      instagram: "plright",
                                      link: "https://parkyunjung.tistory.com",
                                      cardDescription: "Project Manager",
                                      phoneNumber: "",
                                      isMincho: true,
                                      isSoju: false,
                                      isBoomuk: false,
                                      isSauced: true,
                                      oneTmi: "먹는거 잠자는거 좋아해요",
                                      twoTmi: "일벌리기도 좋아하는데 체력이..",
                                      threeTmi: "내가 바로 나다 기획자😎"),
                                 Card(cardID: "card",
                                      background: "imgChae",
                                      title: "NADA",
                                      name: "이채연",
                                      birthDate: "1998.01.09 (24)",
                                      mbti: "ENFP",
                                      instagram: "chaens_",
                                      link: "https://chaens.tistory.com",
                                      cardDescription: "Designer",
                                      phoneNumber: "",
                                      isMincho: true,
                                      isSoju: true,
                                      isBoomuk: false,
                                      isSauced: false,
                                      oneTmi: "카톡 임티 62개 + 이모티콘 플러스 구독",
                                      twoTmi: "빵, 디저트 좋아해요 🥞🍞🍰🍦🍩🍪",
                                      threeTmi: "ENFP와 ENFJ 그 사이!"),
                                 Card(cardID: "card",
                                      background: "imgHyun",
                                      title: "NADA",
                                      name: "김현규",
                                      birthDate: "1997/05/02 (25)",
                                      mbti: "ENTJ",
                                      instagram: "hyungggyu",
                                      link: "https://github.com/hyun99999",
                                      cardDescription: "iOS Developer",
                                      phoneNumber: "",
                                      isMincho: false,
                                      isSoju: false,
                                      isBoomuk: true,
                                      isSauced: false,
                                      oneTmi: "악으로 깡으로 악깡규",
                                      twoTmi: "후드티 주세요 후드티",
                                      threeTmi: "스트로베리 문 한스쿱"),
                                 Card(cardID: "card",
                                      background: "imgYi",
                                      title: "NADA",
                                      name: "최이준",
                                      birthDate: "1999.04.06 (23)",
                                      mbti: "ISFJ",
                                      instagram: "dlwns_33",
                                      link: "https://github.com/dlwns33",
                                      cardDescription: "iOS Developer",
                                      phoneNumber: "",
                                      isMincho: false,
                                      isSoju: true,
                                      isBoomuk: false,
                                      isSauced: false,
                                      oneTmi: "노는게제일좋아 친구들 모..이면 낯가려요",
                                      twoTmi: "축구야구가좋아요 스포츠좋아",
                                      threeTmi: "난 슬플때 컵을 쌓아..."),
                                 Card(cardID: "card",
                                      background: "imgMin",
                                      title: "NADA",
                                      name: "이민재",
                                      birthDate: "2000.03.28 (22)",
                                      mbti: "ESFJ",
                                      instagram: "minimin.0_0",
                                      link: "https://github.com/mini-min",
                                      cardDescription: "iOS Developer",
                                      phoneNumber: "",
                                      isMincho: false,
                                      isSoju: false,
                                      isBoomuk: false,
                                      isSauced: false,
                                      oneTmi: "나다 만들고 국방의 의무",
                                      twoTmi: "믿기지 않겠지만, 전 야구선수 출신",
                                      threeTmi: "천안-서울 쉽지않네;;"),
                                 Card(cardID: "card",
                                      background: "imgYe",
                                      title: "NADA",
                                      name: "오예원",
                                      birthDate: "1999.05.12 (23)",
                                      mbti: "ENFP",
                                      instagram: "yae0ni",
                                      link: "https://github.com/yaeoni",
                                      cardDescription: "Server Developer",
                                      phoneNumber: "",
                                      isMincho: false,
                                      isSoju: true,
                                      isBoomuk: false,
                                      isSauced: true,
                                      oneTmi: "예옹. 에옹. 야옹. 에원. 에엉. 맘가는 대로..",
                                      twoTmi: "제법 귀엽다.",
                                      threeTmi: "")]
    
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
