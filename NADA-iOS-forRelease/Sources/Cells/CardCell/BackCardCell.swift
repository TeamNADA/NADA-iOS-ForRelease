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
        if isMintImage == true {
            self.mintImageView.image = UIImage(named: "iconTasteOnMincho")
        } else {
            self.mintImageView.image = UIImage(named: "iconTasteOffMincho")
        }
        if isNoMintImage == true {
            self.noMintImageView.image = UIImage(named: "iconTasteOnBanmincho")
        } else {
            self.noMintImageView.image = UIImage(named: "iconTasteOffBanmincho")
        }
        if isSojuImage == true {
            self.sojuImageView.image = UIImage(named: "iconTasteOnSoju")
        } else {
            self.sojuImageView.image = UIImage(named: "iconTasteOffSoju")
        }
        if isBeerImage == true {
            self.beerImageView.image = UIImage(named: "iconTasteOnBeer")
        } else {
            self.beerImageView.image = UIImage(named: "iconTasteOffBeer")
        }
        if isPourImage == true {
            self.pourEatImageView.image = UIImage(named: "iconTasteOnBumeok")
        } else {
            self.pourEatImageView.image = UIImage(named: "iconTasteOffBumeok")
        }
        if isPutSauceImage == true {
            self.putSauceEatImageView.image = UIImage(named: "iconTasteOnZzik")
        } else {
            self.putSauceEatImageView.image = UIImage(named: "iconTasteOffZzik")
        }
        if isYangnyumImage == true {
            self.sauceChickenImageView.image = UIImage(named: "iconTasteOnSeasoned")
        } else {
            self.sauceChickenImageView.image = UIImage(named: "iconTasteOffSeasoned")
        }
        if isFriedImage == true {
            self.friedChickenImageView.image = UIImage(named: "iconTasteOnFried")
        } else {
            self.friedChickenImageView.image = UIImage(named: "iconTasteOffFried")
        }
        self.firstTmiLabel.text = firstTmi
        self.secondTmiLabel.text = secondTmi
        self.thirdTmiLabel.text = thirdTmi
    }
}
