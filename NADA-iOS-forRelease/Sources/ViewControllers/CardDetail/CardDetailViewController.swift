//
//  CardDetailViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/07.
//

import UIKit

class CardDetailViewController: UIViewController {
    
    // MARK: - Properties
    // 네비게이션 바
    @IBAction func touchBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func presentHarmonyViewController(_ sender: Any) {
        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.cardHarmony, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardHarmonyViewController) as? CardHarmonyViewController else { return }
        
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    public var frontCardDataModel: FrontCardDataModel?
    public var backCardDataModel: BackCardDataModel?
    public var cardBackgroundImage: UIImage?
    
    private var isFront = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let changeGroup = UIAction(title: "그룹 변경",
                                   handler: { _ in
            let nextVC = SelectGroupBottomSheetViewController()
                        .setTitle("그룹선택")
                        .setHeight(386)
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: false, completion: nil)
        })
        let deleteCard = UIAction(title: "명함 삭제",
                                  handler: { _ in
            self.makeCancelDeleteAlert(title: "명함 삭제",
                                       message: "명함을 정말 삭제하시겠습니까?",
                                       deleteAction: { _ in
                // TODO: 명함 삭제 서버통신
            }) })
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("즐겨찾기") })
        
        optionButton.menu = UIMenu(identifier: nil,
                                   options: .displayInline,
                                   children: [changeGroup, deleteCard, cancel])
        optionButton.showsMenuAsPrimaryAction = true

        setFrontCard()
        setGestureRecognizer()
    }

}

extension CardDetailViewController {
    private func setFrontCard() {
        guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
        
        frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
        guard let frontCardDataModel = frontCardDataModel else { return }
        frontCard.initCell(cardBackgroundImage, frontCardDataModel.title, frontCardDataModel.description, frontCardDataModel.name, frontCardDataModel.birthDate, frontCardDataModel.mbti, frontCardDataModel.instagramID, frontCardDataModel.linkURL)
        
        cardView.addSubview(frontCard)
    }
    private func setGestureRecognizer() {
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(transitionCardWithAnimation(_:)))
        swipeLeftGestureRecognizer.direction = .left
        self.cardView.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(transitionCardWithAnimation(_:)))
        swipeRightGestureRecognizer.direction = .right
        self.cardView.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func transitionCardWithAnimation(_ swipeGesture: UISwipeGestureRecognizer) {
        if isFront {
            guard let backCard = BackCardCell.nib().instantiate(withOwner: self, options: nil).first as? BackCardCell else { return }
            guard let backCardDataModel = backCardDataModel else { return }
            backCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            backCard.initCell(cardBackgroundImage,
                              backCardDataModel.isMincho,
                              backCardDataModel.isSoju,
                              backCardDataModel.isBoomuk,
                              backCardDataModel.isSauced,
                              backCardDataModel.firstTMI,
                              backCardDataModel.secondTMI,
                              backCardDataModel.thirdTMI)
            
            cardView.addSubview(backCard)
            isFront = false
        } else {
            guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let frontCardDataModel = frontCardDataModel else { return }
            frontCard.initCell(cardBackgroundImage,
                               frontCardDataModel.title,
                               frontCardDataModel.description,
                               frontCardDataModel.name,
                               frontCardDataModel.birthDate,
                               frontCardDataModel.mbti,
                               frontCardDataModel.instagramID,
                               frontCardDataModel.linkURL)
            
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
