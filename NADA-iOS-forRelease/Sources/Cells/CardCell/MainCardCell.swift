//
//  MainCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/10.
//

import UIKit
import VerticalCardSwiper
import KakaoSDKCommon

class MainCardCell: CardCell {

    // MARK: - Properties
    
    private var isFront = true
    private enum Size {
        static let cellHeight: CGFloat = 540
        static let cellWidth: CGFloat = 327
    }
    
    public var isShareable: Bool?
    public var cardDataModel: Card?
    public var cardType: CardType?
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setGestureRecognizer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.frame = CGRect(x: 0, y: 0, width: Size.cellWidth, height: Size.cellHeight)
    }
    
    // MARK: - Methods
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.mainCardCell, bundle: Bundle(for: MainCardCell.self))
    }
}

// MARK: - Extensions

extension MainCardCell {
    public func setFrontCard() {
        guard let cardType else { return }
        
        switch cardType {
        case .basic:
            guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            frontCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable ?? false)
            
            contentView.addSubview(frontCard)
        case .company:
            return
        case .fan:
            guard let frontCard = FanFrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FanFrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            frontCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable ?? false)
            
            contentView.addSubview(frontCard)
        }
    }
    private func setGestureRecognizer() {
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(transitionCardWithAnimation(_:)))
        swipeLeftGestureRecognizer.direction = .left
        self.contentView.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(transitionCardWithAnimation(_:)))
        swipeRightGestureRecognizer.direction = .right
        self.contentView.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    public func initCell(cardDataModel: Card) {
        self.cardDataModel = cardDataModel
    }
    // MARK: - @objc Methods
    
    @objc
    private func transitionCardWithAnimation(_ swipeGesture: UISwipeGestureRecognizer) {
        if isFront {
            guard let backCard = BackCardCell.nib().instantiate(withOwner: self, options: nil).first as? BackCardCell else { return }
            backCard.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            backCard.initCell(cardTasteInfo: cardDataModel.cardTastes, tmi: cardDataModel.tmi)
            
            contentView.addSubview(backCard)
            isFront = false
        } else {
            setFrontCard()
            isFront = true
        }
        if swipeGesture.direction == .right {
            UIView.transition(with: contentView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil) { _ in
                self.contentView.subviews[0].removeFromSuperview()
            }
        } else {
            UIView.transition(with: contentView, duration: 0.5, options: .transitionFlipFromRight, animations: nil) { _ in
                self.contentView.subviews[0].removeFromSuperview()
            }
        }
    }
}
