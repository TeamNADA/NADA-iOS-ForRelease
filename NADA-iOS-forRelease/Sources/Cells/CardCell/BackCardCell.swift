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
    @IBOutlet weak var mintImageView: UIImageView!
    @IBOutlet weak var noMintImageView: UIImageView!
    @IBOutlet weak var sojuImageView: UIImageView!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var pourEatImageView: UIImageView!
    @IBOutlet weak var putSauceEatImageView: UIImageView!
    @IBOutlet weak var sauceChickenImageView: UIImageView!
    @IBOutlet weak var friedChickenImageView: UIImageView!
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
        return UINib(nibName: "BackCardCell", bundle: nil)
    }
}

// MARK: - Extensions
extension BackCardCell {
    private func setUI() {
        
    }
    
    func initCell(_ backgroundImage: String,
                  _ mintImage: String,
                  _ noMintImage: String,
                  _ sojuImage: String,
                  _ beerImage: String,
                  _ pourImage: String,
                  _ putSauceImage: String,
                  _ yangnyumImage: String,
                  _ friedImage: String,
                  _ firstTmi: String,
                  _ secondTmi: String,
                  _ thirdTmi: String) {
        if let bgImage = UIImage(named: backgroundImage) {
            self.backgroundImageView.image = bgImage
        }
        if let mtImage = UIImage(named: mintImage) {
            self.mintImageView.image = mtImage
        }
        if let noMtImage = UIImage(named: noMintImage) {
            self.noMintImageView.image = noMtImage
        }
        if let sojuImage = UIImage(named: sojuImage) {
            self.sojuImageView.image = sojuImage
        }
        if let beerImage = UIImage(named: beerImage) {
            self.beerImageView.image = beerImage
        }
        if let bumukImage = UIImage(named: pourImage) {
            self.pourEatImageView.image = bumukImage
        }
        if let jjikmukImage = UIImage(named: putSauceImage) {
            self.putSauceEatImageView.image = jjikmukImage
        }
        if let yangnyumImage = UIImage(named: yangnyumImage) {
            self.sauceChickenImageView.image = yangnyumImage
        }
        if let friedImage = UIImage(named: friedImage) {
            self.friedChickenImageView.image = friedImage
        }

        self.firstTmiLabel.text = firstTmi
        self.secondTmiLabel.text = secondTmi
        self.thirdTmiLabel.text = thirdTmi
    }
}
