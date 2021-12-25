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
    enum Status {
        case group
        case add
    }
    
    @IBAction func touchBackButton(_ sender: Any) {
        switch status {
        case .group:
            self.navigationController?.popViewController(animated: true)
        case .add:
            self.dismiss(animated: true, completion: nil)
            presentingViewController?.viewWillAppear(true)
        }
    }
    
    @IBAction func presentHarmonyViewController(_ sender: Any) {
        // TODO: 궁합 서버통신
        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.cardHarmony, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardHarmonyViewController) as? CardHarmonyViewController else { return }
        
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    
    public var cardDataModel: Card?
    private var isShareable: Bool = false
    
    private var isFront = true
    var status: Status = .group
    var serverGroups: Groups?
    var groupId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setMenu()
        setFrontCard()
        setGestureRecognizer()
    }

}

extension CardDetailViewController {
    func cardDeleteInGroupWithAPI(groupID: Int, cardID: String) {
        GroupAPI.shared.cardDeleteInGroup(groupID: groupID, cardID: cardID) { response in
            switch response {
            case .success:
                print("cardDeleteInGroupWithAPI - success")
                self.navigationController?.popViewController(animated: true)
            case .requestErr(let message):
                print("cardDeleteInGroupWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardDeleteInGroupWithAPI - pathErr")
            case .serverErr:
                print("cardDeleteInGroupWithAPI - serverErr")
            case .networkFail:
                print("cardDeleteInGroupWithAPI - networkFail")
            }
            
        }
    }
}

extension CardDetailViewController {
    private func setUI() {
        switch status {
        case .group:
            backButton.setImage(UIImage(named: "iconArrow"), for: .normal)
        case .add:
            backButton.setImage(UIImage(named: "iconClear"), for: .normal)
        }
        idLabel.text = cardDataModel?.cardID
    }
    private func setMenu() {
        let changeGroup = UIAction(title: "그룹 변경",
                                   handler: { _ in
            let nextVC = SelectGroupBottomSheetViewController()
                        .setTitle("그룹선택")
                        .setHeight(386)
            nextVC.status = .detail
            nextVC.groupId = self.groupId
            nextVC.serverGroups = self.serverGroups
            nextVC.cardDataModel = self.cardDataModel
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: false, completion: nil)
        })
        let deleteCard = UIAction(title: "명함 삭제",
                                  handler: { _ in
            self.makeCancelDeleteAlert(title: "명함 삭제",
                                       message: "명함을 정말 삭제하시겠습니까?",
                                       deleteAction: { _ in
                // 명함 삭제 서버통신
                self.cardDeleteInGroupWithAPI(groupID: self.groupId ?? 0, cardID: self.cardDataModel?.cardID ?? "")
            }) })
        let options = UIMenu(title: "options", options: .displayInline, children: [changeGroup, deleteCard])
        
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("취소") })
        
        optionButton.menu = UIMenu(identifier: nil,
                                   options: .displayInline,
                                   children: [options, cancel])
        optionButton.showsMenuAsPrimaryAction = true
    }
    private func setFrontCard() {
        guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
        
        frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
        frontCard.initCell(cardDataModel?.background ?? "",
                           cardDataModel?.title ?? "",
                           cardDataModel?.cardDescription ?? "",
                           cardDataModel?.name ?? "",
                           cardDataModel?.birthDate ?? "",
                           cardDataModel?.mbti ?? "",
                           cardDataModel?.instagram ?? "",
                           cardDataModel?.link ?? "",
                           isShareable: isShareable)
        
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
            backCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            backCard.initCell(cardDataModel?.background ?? "",
                              cardDataModel?.isMincho ?? true,
                              cardDataModel?.isSoju ?? true,
                              cardDataModel?.isBoomuk ?? true,
                              cardDataModel?.isSauced ?? true,
                              cardDataModel?.oneTmi ?? "",
                              cardDataModel?.twoTmi ?? "",
                              cardDataModel?.threeTmi ?? "",
                              isShareable: isShareable)
            
            cardView.addSubview(backCard)
            isFront = false
        } else {
            guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            frontCard.initCell(cardDataModel?.background ?? "",
                               cardDataModel?.title ?? "",
                               cardDataModel?.cardDescription ?? "",
                               cardDataModel?.name ?? "",
                               cardDataModel?.birthDate ?? "",
                               cardDataModel?.mbti ?? "",
                               cardDataModel?.instagram ?? "",
                               cardDataModel?.link ?? "",
                               isShareable: isShareable)
            
            cardView.addSubview(frontCard)
            isFront = true
        }
        if swipeGesture.direction == .right {
            UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil) { _ in
                self.cardView.subviews[0].removeFromSuperview()
            }
        } else {
            UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromRight, animations: nil) { _ in
                self.cardView.subviews[0].removeFromSuperview()
            }
        }
    }
}
