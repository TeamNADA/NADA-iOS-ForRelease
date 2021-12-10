//
//  MainCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/10.
//

import UIKit
import VerticalCardSwiper

class MainCardCell: CardCell {

    // MARK: - Properties
    
    private var isFront = true
    
    public var cardDataModel: Card?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var cardView: UIView!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setGestureRecognizer()
    }
}

// MARK: - Extensions

extension MainCardCell {
    private func setGestureRecognizer() {
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(transitionCardWithAnimation(_:)))
        swipeLeftGestureRecognizer.direction = .left
        self.cardView.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(transitionCardWithAnimation(_:)))
        swipeRightGestureRecognizer.direction = .right
        self.cardView.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    private func setFrontCard() {
        guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
        
        frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
        guard let cardDataModel = cardDataModel else { return }
        frontCard.initCell(cardDataModel.background,
                           cardDataModel.title,
                           cardDataModel.cardDescription ?? "",
                           cardDataModel.name,
                           cardDataModel.birthDate,
                           cardDataModel.mbti,
                           cardDataModel.instagram ?? "",
                           cardDataModel.link ?? "")
        
        cardView.addSubview(frontCard)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func transitionCardWithAnimation(_ swipeGesture: UISwipeGestureRecognizer) {
        if isFront {
            guard let backCard = BackCardCell.nib().instantiate(withOwner: self, options: nil).first as? BackCardCell else { return }
            backCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            backCard.initCell(cardDataModel.background,
                              cardDataModel.isMincho,
                              cardDataModel.isSoju,
                              cardDataModel.isBoomuk,
                              cardDataModel.isSauced,
                              cardDataModel.oneTMI ?? "",
                              cardDataModel.twoTMI ?? "",
                              cardDataModel.thirdTMI ?? "")
            
            cardView.addSubview(backCard)
            isFront = false
        } else {
            guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            frontCard.initCell(cardDataModel.background,
                               cardDataModel.title,
                               cardDataModel.cardDescription ?? "",
                               cardDataModel.name,
                               cardDataModel.birthDate,
                               cardDataModel.mbti,
                               cardDataModel.instagram ?? "",
                               cardDataModel.link ?? "")
            
            cardView.addSubview(frontCard)
            isFront = true
        }
        if swipeGesture.direction == .right {
            UIView.transition(with: cardView, duration: 1, options: .transitionFlipFromLeft, animations: nil) { _ in
                self.cardView.subviews[0].removeFromSuperview()
            }
        } else {
            UIView.transition(with: cardView, duration: 1, options: .transitionFlipFromRight, animations: nil) { _ in
                self.cardView.subviews[0].removeFromSuperview()
            }
        }
        
    }
}
