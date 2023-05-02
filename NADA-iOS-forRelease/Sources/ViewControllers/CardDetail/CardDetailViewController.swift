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
        switch status {
        case .group:
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
    
    @IBAction func presentHarmonyViewController(_ sender: Any) {
        cardHarmonyFetchWithAPI(myCard: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.firstCardID) ?? "",
                                yourCard: cardDataModel?.cardUUID ?? "")
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
    
    func cardHarmonyFetchWithAPI(myCard: String, yourCard: String) {
        UtilAPI.shared.cardHarmonyFetch(myCard: myCard, yourCard: yourCard) { response in
            switch response {
            case .success(let data):
                if let harmony = data as? HarmonyResponse {
                    guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.cardHarmony, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardHarmonyViewController) as? CardHarmonyViewController else { return }
                    nextVC.harmonyData = self.updateHarmony(percentage: harmony.harmony)
                    nextVC.modalPresentationStyle = .overFullScreen
                    self.present(nextVC, animated: false, completion: nil)
                }
            case .requestErr(let message):
                print("cardHarmonyFetchWithAPI - requestErr: \(message)")
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
                self.cardDeleteInGroupWithAPI(cardUUID: self.cardDataModel?.cardUUID ?? "", cardGroupName: self.groupName ?? "")
            }) })
        let options = UIMenu(title: "options", options: .displayInline, children: [changeGroup, deleteCard])
        
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("취소") })
        
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
            
            cardView.addSubview(frontCard)
        case .company:
            guard let frontCard = CompanyFrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? CompanyFrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            frontCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable)
            
            cardView.addSubview(frontCard)
        case .fan:
            guard let frontCard = FanFrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FanFrontCardCell else { return }
            
            frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
            guard let cardDataModel = cardDataModel else { return }
            frontCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable)
            
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
    private func updateHarmony(percentage: Int) -> HarmonyData {
        switch percentage {
        case 0 ... 20:
            return HarmonyData(icon: "icnHarmonyRed", percentage: "\(String(percentage))%",
                               color: .harmonyRed, description: "좀 더 친해지길 바라..😅")
        case 21 ... 40:
            return HarmonyData(icon: "icnHarmonyOrange", percentage: "\(String(percentage))%",
                               color: .harmonyOrange, description: "마음만은 찰떡궁합!🙃")
        case 41 ... 60:
            return HarmonyData(icon: "icnHarmonyGreen", percentage: "\(String(percentage))%",
                               color: .harmonyGreen, description: "이 정도면 제법 친한 사이😛")
        case 61 ... 80:
            return HarmonyData(icon: "icnHarmonyYellow", percentage: "\(String(percentage))%",
                               color: .harmonyYellow, description: "우리 사이 척하면 척!😝")
        case 81 ... 100:
            return HarmonyData(icon: "icnHarmonyPurple", percentage: "\(String(percentage))%",
                               color: .harmonyPurple, description: "더할 나위 없이 완벽한 사이!😍")
        default:
            return HarmonyData(icon: "icnHarmonyRed", percentage: "\(String(percentage))%",
                               color: .harmonyRed, description: "")
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
            backCard.initCell(cardTasteInfo: cardDataModel.cardTastes, tmi: cardDataModel.tmi)
            
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
