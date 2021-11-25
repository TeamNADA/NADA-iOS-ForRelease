//
//  CardCreationViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit

class CardCreationViewController: UIViewController {

    // MARK: - Properties
    
    enum ButtonState {
        case enable
        case disable
    }
    
    var completeButtonIsEnabled: ButtonState = .disable {
        didSet {
            if completeButtonIsEnabled == .disable {
                completeButton.isEnabled = false
                if #available(iOS 15.0, *) {
                    completeButton.setNeedsUpdateConfiguration()
                }
            } else {
                completeButton.isEnabled = true
                if #available(iOS 15.0, *) {
                    completeButton.setNeedsUpdateConfiguration()
                }
            }
        }
    }
    
    private var frontCardIsEmpty = true
    private var backCardIsEmpty = true
    private var restoreFrameYValue = 0.0
    private var currentIndex = 0
    private var cardData: Card?
    private var cardCreationRequest: CardCreationRequest?
    private var frontCard: FrontCardDataModel?
    private var backCard: BackCardDataModel?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var creationTextLabel: UILabel!
    @IBOutlet weak var frontTextLabel: UILabel!
    @IBOutlet weak var backTextLabel: UILabel!

    @IBOutlet weak var statusMovedView: UIView!
    @IBOutlet weak var cardCreationCollectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        registerCell()
        setTextLabelGesture()
        
        // FIXME: 서버통신 테스트 중. 추후 호출 위치 변경.
//        cardDetailFetchWithAPI(cardID: "cardA")
        
        // FIXME: group.서버통신 테스트 중. 추후 호출 위치 변경.
//        let changeGroupRequest = ChangeGroupRequest(cardID: "cardA",
//                                                    userID: "nada2",
//                                                    groupID: 3,
//                                                    newGroupID: 2)
//        changeGroupWithAPI(request: changeGroupRequest)
        
        // FIXME: group.서버통신 테스트 중. 추후 호출 위치 변경.
//        cardDeleteInGroupWithAPI(groupID: 3, cardID: "cardA")
    }
    
    // MARK: - @IBAction Properties

    @IBAction func dismissToPreviousView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pushToCardCompletionView(_ sender: Any) {
        // TODO: - CardCompletionView 화면전환
    }
}

// MARK: - Extensions
extension CardCreationViewController {
    private func setUI() {
        // view.backgroundColor = .white1
        // statusMovedView.backgroundColor = .white1
        // cardCreationCollectionView.backgroundColor = .black1
        cardCreationCollectionView.isPagingEnabled = true
        
        creationTextLabel.text = "명함 생성"
        // creationTextLabel.font = .menu
        // creationTextLabel.textColor = .white1
        
        frontTextLabel.text = "앞면"
        // frontTextLabel.font = .menuSub
        // frontTextLabel.textColor = .white1
        
        backTextLabel.text = "뒷면"
        // backTextLabel.font = .menuSub
        // backTextLabel.textColor = .hintGray1
        
        closeButton.setImage(UIImage(named: "closeBlack"), for: .normal)
        closeButton.setTitle("", for: .normal)
        
        // completeButton.titleLabel?.font = .btn
        completeButton.layer.cornerRadius = 10
        completeButton.isEnabled = false
        
        // MARK: - #available(iOS 15.0, *)
        if #available(iOS 15.0, *) {
            let config = UIButton.Configuration.filled()
            completeButton.configuration = config
            
            let configHandler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .disabled:
                    button.configuration?.title = "완료"
                    // button.configuration?.baseBackgroundColor = .inputBlack2
                    // button.configuration?.baseForegroundColor = .hintGray1
                default:
                    button.configuration?.title = "완료"
                    // button.configuration?.baseBackgroundColor = .mainBlue
                    // button.configuration?.baseForegroundColor = .white1
                }
            }
            completeButton.configurationUpdateHandler = configHandler
        } else {
            completeButton.setTitle("완료", for: .normal)
            // completeButton.setTitleColor(.white1, for: .normal)
        // TODO: - 뷰 확정되면 이미지로 background 세팅
        //        completeButton.setBackgroundImage(, for: .normal)
        
        // completeButton.setTitleColor(.hintGray1, for: .disabled)
        //        completeButton.setBackgroundImage(, for: .disabled)
    }
        
        let cardCreationCollectionViewlayout = cardCreationCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        cardCreationCollectionViewlayout?.scrollDirection = .horizontal
        cardCreationCollectionViewlayout?.estimatedItemSize = .zero
        cardCreationCollectionView.showsHorizontalScrollIndicator = false
        cardCreationCollectionView.showsVerticalScrollIndicator = false
    }
    private func registerCell() {
        cardCreationCollectionView.delegate = self
        cardCreationCollectionView.dataSource = self

        cardCreationCollectionView.register(FrontCardCreationCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.frontCardCreationCollectionViewCell)
        cardCreationCollectionView.register(BackCardCreationCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.backCardCreationCollectionViewCell)
    }
    private func setTextLabelGesture() {
        let tapFrontTextLabelGesture = UITapGestureRecognizer(target: self, action: #selector(dragToFront))
        frontTextLabel.addGestureRecognizer(tapFrontTextLabelGesture)
        frontTextLabel.isUserInteractionEnabled = true
        let tapBackTextLabelGesture = UITapGestureRecognizer(target: self, action: #selector(dragToBack))
        backTextLabel.addGestureRecognizer(tapBackTextLabelGesture)
        backTextLabel.isUserInteractionEnabled = true
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func dragToBack() {
        let indexPath = IndexPath(item: 1, section: 0)
        cardCreationCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        if currentIndex == 0 {
            UIView.animate(withDuration: 0.3) {
                self.statusMovedView.transform = CGAffineTransform(translationX: self.backTextLabel.frame.origin.x - self.statusMovedView.frame.origin.x + 5, y: 0)
            }
            currentIndex = 1
            // self.frontTextLabel.textColor = .hintGray1
            // self.backTextLabel.textColor = .white1
        }
    }
    @objc
    private func dragToFront() {
        if currentIndex == 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            cardCreationCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.statusMovedView.transform = .identity
            }
            currentIndex = 0
            // self.frontTextLabel.textColor = .white1
            // self.backTextLabel.textColor = .hintGray1
        }
    }
}

// MARK: - Network
extension CardCreationViewController {
    func cardDetailFetchWithAPI(cardID: String) {
        CardAPI.shared.cardDetailFetch(cardID: cardID) { response in
            switch response {
            case .success(let data):
                if let card = data as? Card {
                    self.cardData = card
                }
            case .requestErr(let message):
                print("cardDetailFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardDetailFetchWithAPI - pathErr")
            case .serverErr:
                print("cardDetailFetchWithAPI - serverErr")
            case .networkFail:
                print("cardDetailFetchWithAPI - networkFail")
            }
        }
    }

    // TODO: - group 서버통신. 위치변경.
    func changeGroupWithAPI(request: ChangeGroupRequest) {
        GroupAPI.shared.changeCardGroup(request: request) { response in
            switch response {
            case .success:
                print("changeGroupWithAPI - success")
            case .requestErr(let message):
                print("changeGroupWithAPI - requestErr: \(message)")
            case .pathErr:
                print("changeGroupWithAPI - pathErr")
            case .serverErr:
                print("changeGroupWithAPI - serverErr")
            case .networkFail:
                print("changeGroupWithAPI - networkFail")
            }
        }
    }
    // TODO: - group 서버통신. 위치변경.
    func cardDeleteInGroupWithAPI(groupID: Int, cardID: String) {
        GroupAPI.shared.cardDeleteInGroup(groupID: groupID, cardID: cardID) { response in
            switch response {
            case .success:
                print("cardDeleteInGroupWithAPI - success")
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

// MARK: - UICollectionViewDelegate
extension CardCreationViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetIndex = targetContentOffset.pointee.x / scrollView.frame.size.width
        if targetIndex == 1 && currentIndex == 0 {
            UIView.animate(withDuration: 0.2) {
                self.statusMovedView.transform = CGAffineTransform(translationX: self.backTextLabel.frame.origin.x - self.statusMovedView.frame.origin.x + 5, y: 0)
            }
            currentIndex = 1
            // self.frontTextLabel.textColor = .hintGray1
            // self.backTextLabel.textColor = .white
        } else if targetIndex == 0 && currentIndex == 1 {
            UIView.animate(withDuration: 0.2) {
                self.statusMovedView.transform = .identity
            }
            currentIndex = 0
            // self.frontTextLabel.textColor = .white1
            // self.backTextLabel.textColor = .hintGray1
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CardCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cardCreationCollectionView {
            if indexPath.item == 0 {
                guard let frontCreationCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.frontCardCreationCollectionViewCell, for: indexPath) as? FrontCardCreationCollectionViewCell else {
                    return UICollectionViewCell()
                }
                frontCreationCell.frontCardCreationDelegate = self
                return frontCreationCell
            } else if indexPath.item == 1 {
                guard let backCreationCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.backCardCreationCollectionViewCell, for: indexPath) as? BackCardCreationCollectionViewCell else {
                    return UICollectionViewCell()
                }
                backCreationCell.backCardCreationDelegate = self
                return backCreationCell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CardCreationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CardCreationViewController: FrontCardCreationDelegate {
    func frontCardCreation(requiredInfo valid: Bool) {
        frontCardIsEmpty = !valid
        if frontCardIsEmpty == false && backCardIsEmpty == false {
            completeButtonIsEnabled = .enable
        } else {
            completeButtonIsEnabled = .disable
        }
    }

    func frontCardCreation(withRequired requiredInfo: [String: String], withOptional optionalInfo: [String: String]) {
        frontCard = FrontCardDataModel(defaultImage: Int(requiredInfo["defaultImage"] ?? "0") ?? 0,
                              title: requiredInfo["title"]  ?? "",
                              name: requiredInfo["name"] ?? "",
                              birthDate: requiredInfo["birthDate"] ?? "",
                              mbti: requiredInfo["mbti"] ?? "",
                              instagram: optionalInfo["instagram"] ?? "",
                              linkName: optionalInfo["linkName"] ?? "",
                              link: optionalInfo["link"] ?? "",
                              description: optionalInfo["description"] ?? "")
    }
}

extension CardCreationViewController: BackCardCreationDelegate {
    func backCardCreation(requiredInfo valid: Bool) {
        func checkBackRequiredInfo(_ valid: Bool) {
            backCardIsEmpty = !valid
            if frontCardIsEmpty == false && backCardIsEmpty == false {
                completeButtonIsEnabled = .enable
            } else {
                completeButtonIsEnabled = .disable
            }
        }
    }
    func backCardCreation(withRequired requiredInfo: [String: Bool], withOptional optionalInfo: [String: String]) {
        backCard = BackCardDataModel(isMincho: requiredInfo["isMincho"] ?? false,
                            isSoju: requiredInfo["isSoju"] ?? false,
                            isBoomuk: requiredInfo["isBoomuk"] ?? false,
                            isSauced: requiredInfo["isSauced"] ?? false,
                            oneQuestion: optionalInfo["oneQuestion"] ?? "",
                            oneAnswer: optionalInfo["oneAnswer"] ?? "",
                            twoQuestion: optionalInfo["twoQuestion"] ?? "",
                            twoAnswer: optionalInfo["twoAnswer"] ?? "")
    }
}
