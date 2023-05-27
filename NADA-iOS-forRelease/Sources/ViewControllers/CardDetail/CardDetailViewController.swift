//
//  CardDetailViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/07.
//

import UIKit

import FirebaseAnalytics

class CardDetailViewController: UIViewController {
    
    // MARK: - Properties
    // 네비게이션 바
    @IBAction func touchBackButton(_ sender: Any) {
        switch status {
        case .group:
            Analytics.logEvent(Tracking.Event.touchCardDetailClose, parameters: nil)
            self.navigationController?.popViewController(animated: true)
        case .add:
            NotificationCenter.default.post(name: .reloadGroupViewController, object: nil)
            self.dismiss(animated: true, completion: nil)
        case .addWithQR:
            NotificationCenter.default.post(name: .reloadGroupViewController, object: nil)
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)

        case .detail:
            return
        }
    }
    
    @IBAction func touchOptionMenu(_ sender: UIButton) {
        Analytics.logEvent(Tracking.Event.touchCardDetailEdit, parameters: nil)
    }
    
    @IBAction func presentHarmonyViewController(_ sender: Any) {
        Analytics.logEvent(Tracking.Event.touchCardDetailHarmony, parameters: nil)
        cardHarmonyFetchWithAPI(cardUUID: cardDataModel?.cardUUID ?? "")
    }
    
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var idStackView: UIStackView!
    @IBOutlet weak var idLabel: UILabel!
    
    public var cardDataModel: Card?
    private var isShareable: Bool = false
    
    private var isFront = true
    var status: Status = .group
    var serverGroups: [String]?
    var groupName: String?
    var cardType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setMenu()
        setFrontCard()
        setGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveDataNotification(_:)), name: Notification.Name.passDataToDetail, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
}

extension CardDetailViewController {
    func cardDeleteInGroupWithAPI(cardUUID: String, cardGroupName: String) {
        GroupAPI.shared.cardDeleteInGroup(cardUUID: cardUUID, cardGroupName: cardGroupName) { response in
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
    
    func cardHarmonyFetchWithAPI(cardUUID: String) {
        UtilAPI.shared.cardHarmonyFetch(cardUUID: cardUUID) { response in
            switch response {
            case .success(let data):
                if let harmony = data as? HarmonyResponse {
                    let nextVC = NewCardHarmonyViewController()
                    nextVC.harmonyData = self.updateHarmony(percentage: harmony, cardtype: self.cardDataModel?.cardType ?? "BASIC")
                    nextVC.modalPresentationStyle = .overFullScreen
                    self.present(nextVC, animated: false, completion: nil)
                }
            case .requestErr(let message):
                print("cardHarmonyFetchWithAPI - requestErr: \(message)")
                self.makeOKAlert(title: "", message: "내 명함이 없어 궁합을 볼 수 없어요!\n지금 명함을 만들러 가볼까요?", okAction: {_ in
                    self.tabBarController?.selectedIndex = 1
                    self.navigationController?.popViewController(animated: true)
                }, completion: nil)
                
            case .pathErr:
                print("cardHarmonyFetchWithAPI - pathErr")
            case .serverErr:
                print("cardHarmonyFetchWithAPI - serverErr")
            case .networkFail:
                print("cardHarmonyFetchWithAPI - networkFail")
            }
        }
    }
}

extension CardDetailViewController {
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.cardDetail
                           ])
    }
    
    private func setUI() {
        switch status {
        case .group:
            backButton.setImage(UIImage(named: "iconArrow"), for: .normal)
        case .add, .addWithQR:
            backButton.setImage(UIImage(named: "iconClear"), for: .normal)
        case .detail:
            return 
        }
        idStackView.isHidden = true
        idLabel.text = cardDataModel?.cardUUID
    }
    private func setMenu() {
        let changeGroup = UIAction(title: "그룹 변경",
                                   handler: { _ in
            Analytics.logEvent(Tracking.Event.touchCardDetailEditGroup, parameters: nil)
            let nextVC = SelectGroupBottomSheetViewController()
                        .setTitle("그룹선택")
                        .setHeight(386)
            nextVC.status = .detail
            nextVC.groupName = self.groupName
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
                Analytics.logEvent(Tracking.Event.touchCardDetailDelete, parameters: nil)
                self.cardDeleteInGroupWithAPI(cardUUID: self.cardDataModel?.cardUUID ?? "", cardGroupName: self.groupName ?? "")
            }) })
        let options = UIMenu(title: "", options: .displayInline, children: [changeGroup, deleteCard])
        
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in
            Analytics.logEvent(Tracking.Event.touchCardDetailCancel, parameters: nil)})
        
        optionButton.menu = UIMenu(identifier: nil,
                                   options: .displayInline,
                                   children: [options, cancel])
        optionButton.showsMenuAsPrimaryAction = true
    }
    private func setFrontCard() {
        guard let cardTypeString = cardDataModel?.cardType,
            let cardType = CardType(rawValue: cardTypeString) else { return }
        
        switch cardType {
        case .basic:
            guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            frontCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable)
            frontCard.cardContext = .group
            
            cardView.addSubview(frontCard)
        case .company:
            guard let frontCard = CompanyFrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? CompanyFrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            frontCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable)
            frontCard.cardContext = .group
            
            cardView.addSubview(frontCard)
        case .fan:
            guard let frontCard = FanFrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FanFrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            frontCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable)
            frontCard.cardContext = .group
            
            cardView.addSubview(frontCard)
        }
    }
    private func setGestureRecognizer() {
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(transitionCardWithAnimation(_:)))
        swipeLeftGestureRecognizer.direction = .left
        self.cardView.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(transitionCardWithAnimation(_:)))
        swipeRightGestureRecognizer.direction = .right
        self.cardView.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    private func updateHarmony(percentage: HarmonyResponse, cardtype: String) -> HarmonyData {
        switch percentage.totalGrade {
        case 0 ... 20:
            return HarmonyData(lottie: 0, mbtiGrade: percentage.mbtiGrade, constellationGrade: percentage.constellationGrade,
                               totalGrade: percentage.totalGrade,
                               color: .harmonyRed, description: "좀 더 친해지길 바라..😅", cardtype: cardtype)
        case 21 ... 40:
            return HarmonyData(lottie: 21, mbtiGrade: percentage.mbtiGrade, constellationGrade: percentage.constellationGrade,
                               totalGrade: percentage.totalGrade,
                               color: .harmonyOrange, description: "마음만은 찰떡궁합!🙃", cardtype: cardtype)
        case 41 ... 60:
            return HarmonyData(lottie: 41, mbtiGrade: percentage.mbtiGrade, constellationGrade: percentage.constellationGrade,
                               totalGrade: percentage.totalGrade,
                               color: .harmonyGreen, description: "이 정도면 제법 친한 사이😛", cardtype: cardtype)
        case 61 ... 80:
            return HarmonyData(lottie: 61, mbtiGrade: percentage.mbtiGrade, constellationGrade: percentage.constellationGrade,
                               totalGrade: percentage.totalGrade,
                               color: .harmonyYellow, description: "우리 사이 척하면 척!😝", cardtype: cardtype)
        case 81 ... 100:
            return HarmonyData(lottie: 81, mbtiGrade: percentage.mbtiGrade, constellationGrade: percentage.constellationGrade,
                               totalGrade: percentage.totalGrade,
                               color: .harmonyPurple, description: "더할 나위 없이 완벽한 사이!😍", cardtype: cardtype)
        default:
            return HarmonyData(lottie: 0, mbtiGrade: percentage.mbtiGrade, constellationGrade: percentage.constellationGrade,
                               totalGrade: percentage.totalGrade,
                               color: .harmonyRed, description: "", cardtype: "BASIC")
        }
   
    }
    
    // MARK: - @objc Methods
    
    @objc func didRecieveDataNotification(_ notification: Notification) {
        groupName = notification.object as? String ?? ""
    }
    
    @objc
    private func transitionCardWithAnimation(_ swipeGesture: UISwipeGestureRecognizer) {
        if isFront {
            guard let backCard = BackCardCell.nib().instantiate(withOwner: self, options: nil).first as? BackCardCell else { return }
            backCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            backCard.initCell(cardDataModel.cardImage, cardDataModel.cardTastes, cardDataModel.tmi)
            
            cardView.addSubview(backCard)
            isFront = false
        } else {
            setFrontCard()
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
