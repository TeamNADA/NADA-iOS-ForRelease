//
//  BackCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/11.
//

import UIKit
import VerticalCardSwiper

class BackCardCell: CardCell {
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tasteTitleLabel: UILabel!
    @IBOutlet weak var mintImageView: UIImageView!
    @IBOutlet weak var noMintImageView: UIImageView!
    @IBOutlet weak var sojuImageView: UIImageView!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var pourEatImageView: UIImageView!
    @IBOutlet weak var putSauceEatImageView: UIImageView!
    @IBOutlet weak var sauceChickenImageView: UIImageView!
    @IBOutlet weak var friedChickenImageView: UIImageView!
    @IBOutlet weak var tmiTitleLabel: UILabel!
    @IBOutlet weak var firstTmiLabel: UILabel!
    @IBOutlet weak var secondTmiLabel: UILabel!
    @IBOutlet weak var thirdTmiLabel: UILabel!
    
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
        tmiTitleLabel.font = .title02
        tmiTitleLabel.textColor = .white
        firstTmiLabel.font = .textRegular04
        firstTmiLabel.textColor = .white
        secondTmiLabel.font = .textRegular04
        secondTmiLabel.textColor = .white
        thirdTmiLabel.font = .textRegular04
        thirdTmiLabel.textColor = .white
    }
    
    func initCell(_ backgroundImage: String,
                  _ isMintImage: Bool,
                  _ isNoMintImage: Bool,
                  _ isSojuImage: Bool,
                  _ isBeerImage: Bool,
                  _ isPourImage: Bool,
                  _ isPutSauceImage: Bool,
                  _ isYangnyumImage: Bool,
                  _ isFriedImage: Bool,
                  _ firstTmi: String,
                  _ secondTmi: String,
                  _ thirdTmi: String) {
        if let bgImage = UIImage(named: backgroundImage) {
            self.backgroundImageView.image = bgImage
        }
        self.mintImageView.image = isMintImage == true ?
        UIImage(named: "iconTasteOnMincho") : UIImage(named: "iconTasteOffMincho")
        self.noMintImageView.image = isNoMintImage == true ?
        UIImage(named: "iconTasteOnBanmincho") : UIImage(named: "iconTasteOffBanmincho")
        self.sojuImageView.image = isSojuImage == true ?
        UIImage(named: "iconTasteOnSoju") : UIImage(named: "iconTasteOffSoju")
        self.beerImageView.image = isBeerImage == true ?
        UIImage(named: "iconTasteOnBeer") : UIImage(named: "iconTasteOffBeer")
        self.pourEatImageView.image = isPourImage == true ?
        UIImage(named: "iconTasteOnBumeok") : UIImage(named: "iconTasteOffBumeok")
        self.putSauceEatImageView.image = isPutSauceImage == true ?
        UIImage(named: "iconTasteOnZzik") : UIImage(named: "iconTasteOffZzik")
        self.sauceChickenImageView.image = isYangnyumImage == true ?
        UIImage(named: "iconTasteOnSeasoned") : UIImage(named: "iconTasteOffSeasoned")
        self.friedChickenImageView.image = isFriedImage == true ?
        UIImage(named: "iconTasteOnFried") : UIImage(named: "iconTasteOffFried")
        self.firstTmiLabel.text = firstTmi
        self.secondTmiLabel.text = secondTmi
        self.thirdTmiLabel.text = thirdTmi
    }
    
    // FIXME: - UIImage 로 넘어올때. 나중에 어떻게 사용할지 정해야함.
    func initCell(_ backgroundImage: UIImage?,
                  _ isMintImage: Bool,
                  _ isNoMintImage: Bool,
                  _ isSojuImage: Bool,
                  _ isBeerImage: Bool,
                  _ isPourImage: Bool,
                  _ isPutSauceImage: Bool,
                  _ isYangnyumImage: Bool,
                  _ isFriedImage: Bool,
                  _ firstTmi: String,
                  _ secondTmi: String,
                  _ thirdTmi: String) {
        
        self.backgroundImageView.image = backgroundImage ?? UIImage()
        self.mintImageView.image = isMintImage == true ?
        UIImage(named: "iconTasteOnMincho") : UIImage(named: "iconTasteOffMincho")
        self.noMintImageView.image = isNoMintImage == true ?
        UIImage(named: "iconTasteOnBanmincho") : UIImage(named: "iconTasteOffBanmincho")
        self.sojuImageView.image = isSojuImage == true ?
        UIImage(named: "iconTasteOnSoju") : UIImage(named: "iconTasteOffSoju")
        self.beerImageView.image = isBeerImage == true ?
        UIImage(named: "iconTasteOnBeer") : UIImage(named: "iconTasteOffBeer")
        self.pourEatImageView.image = isPourImage == true ?
        UIImage(named: "iconTasteOnBumeok") : UIImage(named: "iconTasteOffBumeok")
        self.putSauceEatImageView.image = isPutSauceImage == true ?
        UIImage(named: "iconTasteOnZzik") : UIImage(named: "iconTasteOffZzik")
        self.sauceChickenImageView.image = isYangnyumImage == true ?
        UIImage(named: "iconTasteOnSeasoned") : UIImage(named: "iconTasteOffSeasoned")
        self.friedChickenImageView.image = isFriedImage == true ?
        UIImage(named: "iconTasteOnFried") : UIImage(named: "iconTasteOffFried")
        self.firstTmiLabel.text = firstTmi
        self.secondTmiLabel.text = secondTmi
        self.thirdTmiLabel.text = thirdTmi
    }
}
