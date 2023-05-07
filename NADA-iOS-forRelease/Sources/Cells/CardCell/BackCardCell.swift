//
//  BackCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/11.
//

import UIKit

import VerticalCardSwiper
import Kingfisher

class BackCardCell: CardCell {
    
    // MARK: - Properties
    
    private var cardData: Card?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tasteTitleLabel: UILabel!
    @IBOutlet var tasteImageViews: [UIImageView]!
    @IBOutlet var tasteLabels: [UILabel]!
    @IBOutlet weak var tmiTitleLabel: UILabel!
    @IBOutlet weak var tmiLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    // MARK: - Functions
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.backCardCell, bundle: Bundle(for: BackCardCell.self))
    }
}

// MARK: - Extensions
extension BackCardCell {
    private func setUI() {        
        tasteTitleLabel.font = .title02
        tasteTitleLabel.textColor = .white
        
        for index in 0..<tasteLabels.count {
            tasteLabels[index].font = .button02
            tasteLabels[index].textColor = .tasteLabel
        }
        
        tmiTitleLabel.font = .title02
        tmiTitleLabel.textColor = .white
        
        tmiLabel.font = .textRegular04
        tmiLabel.textColor = .white
        tmiLabel.numberOfLines = 0
    }
    
    /// 명함 미리보기 시 사용.
    func initCell(_ backgroundImage: UIImage?,
                  _ cardTasteInfo: [CardTasteInfo],
                  _ tmi: String?) {
        backgroundImageView.image = backgroundImage
        
        let cardTasteInfo: [CardTasteInfo] = cardTasteInfo.sorted { $0.sortOrder > $1.sortOrder }
        
        for index in stride(from: 0, to: cardTasteInfo.count, by: 2) {
            if cardTasteInfo[index].isChoose {
                tasteImageViews[index / 2].image = UIImage(named: "imgBalanceLeft")
            } else {
                tasteImageViews[index / 2].image = UIImage(named: "imgBalanceRight")
            }
        }
        
        for index in 0..<tasteLabels.count {
            tasteLabels[index].text = cardTasteInfo[index].cardTasteName
            tasteLabels[index].textColor = cardTasteInfo[index].isChoose ? .tasteLabel :  .tasteLabel.withAlphaComponent(0.5)
        }
        
        tmiLabel.text = tmi
    }
    
    /// 명함 조회 시 사용.
    func initCell(_ backgroundImage: String,
                  _ cardTasteInfo: [CardTasteInfo],
                  _ tmi: String?) {
        if backgroundImage.hasPrefix("https://") {
            self.backgroundImageView.updateServerImage(backgroundImage)
        } else {
            if let bgImage = UIImage(named: backgroundImage) {
                self.backgroundImageView.image = bgImage
            }
        }
        
        let cardTasteInfo: [CardTasteInfo] = cardTasteInfo.sorted { $0.sortOrder > $1.sortOrder }
        
        for index in stride(from: 0, to: cardTasteInfo.count, by: 2) {
            if cardTasteInfo[index].isChoose {
                tasteImageViews[index / 2].image = UIImage(named: "imgBalanceLeft")
            } else {
                tasteImageViews[index / 2].image = UIImage(named: "imgBalanceRight")
            }
        }
        
        for index in 0..<tasteLabels.count {
            tasteLabels[index].text = cardTasteInfo[index].cardTasteName
            tasteLabels[index].textColor = cardTasteInfo[index].isChoose ? .tasteLabel :  .tasteLabel.withAlphaComponent(0.5)
        }
        
        tmiLabel.text = tmi
    }
    
    // TODO: - 로컬에서 image 를 가지고 있게 되면 사용할 메서드.
//    /// 서버에서 image 를 URL 로 가져올 경우 사용.
//    func initCellFromServer(cardData: Card, isShareable: Bool) {
//        self.cardData = cardData
//
//        if cardData.background.hasPrefix("https://") {
//            self.backgroundImageView.updateServerImage(cardData.background)
//        } else {
//            if let bgImage = UIImage(named: cardData.background) {
//                self.backgroundImageView.image = bgImage
//            }
//        }
//
//        mintImageView.image = cardData.isMincho == true ?
//        UIImage(named: "iconTasteOnMincho") : UIImage(named: "iconTasteOffMincho")
//        noMintImageView.image = cardData.isMincho == false ?
//        UIImage(named: "iconTasteOnBanmincho") : UIImage(named: "iconTasteOffBanmincho")
//
//        sojuImageView.image = cardData.isSoju == true ?
//        UIImage(named: "iconTasteOnSoju") : UIImage(named: "iconTasteOffSoju")
//        beerImageView.image = cardData.isSoju == false ?
//        UIImage(named: "iconTasteOnBeer") : UIImage(named: "iconTasteOffBeer")
//
//        pourEatImageView.image = cardData.isBoomuk == true ?
//        UIImage(named: "iconTasteOnBumeok") : UIImage(named: "iconTasteOffBumeok")
//        putSauceEatImageView.image = cardData.isBoomuk == false ?
//        UIImage(named: "iconTasteOnZzik") : UIImage(named: "iconTasteOffZzik")
//
//        sauceChickenImageView.image = cardData.isSauced == true ?
//        UIImage(named: "iconTasteOnSeasoned") : UIImage(named: "iconTasteOffSeasoned")
//        friedChickenImageView.image = cardData.isSauced == false ?
//        UIImage(named: "iconTasteOnFried") : UIImage(named: "iconTasteOffFried")
//
//        if let oneTmi = cardData.oneTmi, !oneTmi.isEmpty {
//            firstTmiLabel.text = "•  " + oneTmi
//        } else {
//            firstTmiLabel.text = cardData.oneTmi
//        }
//
//        if let twoTmi = cardData.twoTmi, !twoTmi.isEmpty {
//            secondTmiLabel.text = "•  " + twoTmi
//        } else {
//            secondTmiLabel.text = cardData.twoTmi
//        }
//
//        if let threeTmi = cardData.threeTmi, !threeTmi.isEmpty {
//            thirdTmiLabel.text = "•  " + threeTmi
//        } else {
//            thirdTmiLabel.text = cardData.threeTmi
//        }
//
//        shareButton.isHidden = !isShareable
//    }
//
//    /// 명함생성할 때 image 를 UIImage 로 가져올 경우 사용
//    func initCell(_ backgroundImage: UIImage?,
//                  _ isMint: Bool,
//                  _ isSoju: Bool,
//                  _ isBoomuk: Bool,
//                  _ isSauced: Bool,
//                  _ firstTMI: String,
//                  _ secondTMI: String,
//                  _ thirdTMI: String,
//                  isShareable: Bool) {
//        backgroundImageView.image = backgroundImage ?? UIImage()
//        mintImageView.image = isMint == true ?
//        UIImage(named: "iconTasteOnMincho") : UIImage(named: "iconTasteOffMincho")
//        noMintImageView.image = isMint == false ?
//        UIImage(named: "iconTasteOnBanmincho") : UIImage(named: "iconTasteOffBanmincho")
//
//        sojuImageView.image = isSoju == true ?
//        UIImage(named: "iconTasteOnSoju") : UIImage(named: "iconTasteOffSoju")
//        beerImageView.image = isSoju == false ?
//        UIImage(named: "iconTasteOnBeer") : UIImage(named: "iconTasteOffBeer")
//
//        pourEatImageView.image = isBoomuk == true ?
//        UIImage(named: "iconTasteOnBumeok") : UIImage(named: "iconTasteOffBumeok")
//        putSauceEatImageView.image = isBoomuk == false ?
//        UIImage(named: "iconTasteOnZzik") : UIImage(named: "iconTasteOffZzik")
//
//        sauceChickenImageView.image = isSauced == true ?
//        UIImage(named: "iconTasteOnSeasoned") : UIImage(named: "iconTasteOffSeasoned")
//        friedChickenImageView.image = isSauced == false ?
//        UIImage(named: "iconTasteOnFried") : UIImage(named: "iconTasteOffFried")
//
//        if !firstTMI.isEmpty {
//            firstTmiLabel.text = "•  " + firstTMI
//        } else {
//            firstTmiLabel.text = firstTMI
//        }
//
//        if !secondTMI.isEmpty {
//            secondTmiLabel.text = "•  " + secondTMI
//        } else {
//            secondTmiLabel.text = secondTMI
//        }
//
//        if !thirdTMI.isEmpty {
//            thirdTmiLabel.text = "•  " + thirdTMI
//        } else {
//            thirdTmiLabel.text = thirdTMI
//        }
//
//        shareButton.isHidden = !isShareable
//    }
}
