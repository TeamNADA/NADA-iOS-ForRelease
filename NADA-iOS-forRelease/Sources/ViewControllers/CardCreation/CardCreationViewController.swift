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
    
    private var frontCardRequiredIsEmpty = true
    private var backCardRequiredIsEmpty = true
    private var isEditingMode = false
    private var currentIndex = 0
    private var frontCard: FrontCardDataModel?
    private var backCard: BackCardDataModel?
    private var mbtiText: String?
    private var birthText: String?
    
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
        if isEditingMode {
            makeOKCancelAlert(title: "입력 취소", message: "입력한 내용이 모두 삭제됩니다. 돌아가시겠습니까?", okAction: { _ in
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func pushToCardCompletionView(_ sender: Any) {
        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.cardCreationPreview, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardCreationPreviewViewController) as? CardCreationPreviewViewController else { return }
        
        nextVC.frontCardDataModel = frontCard
        nextVC.backCardDataModel = backCard
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - Extensions
extension CardCreationViewController {
    private func setUI() {
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .background
        statusMovedView.backgroundColor = .secondary
        cardCreationCollectionView.backgroundColor = .background
        cardCreationCollectionView.isPagingEnabled = true
        
        creationTextLabel.text = "명함 생성"
        creationTextLabel.font = .title02
        creationTextLabel.textColor = .primary
        
        frontTextLabel.text = "앞면"
        frontTextLabel.font = .title01
        frontTextLabel.textColor = .primary
        
        backTextLabel.text = "뒷면"
        backTextLabel.font = .title01
        backTextLabel.textColor = .quaternary
        
        closeButton.setImage(UIImage(named: "iconClear"), for: .normal)
        closeButton.setTitle("", for: .normal)
        
        completeButton.titleLabel?.font = .button01
        completeButton.isEnabled = false
        
        // MARK: - #available(iOS 15.0, *)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.background.cornerRadius = 15
            completeButton.configuration = config

            let configHandler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .disabled:
                    button.configuration?.title = "완료"
                    button.configuration?.baseBackgroundColor = .textBox
                    button.configuration?.baseForegroundColor = .white
                default:
                    button.configuration?.title = "완료"
                    button.configuration?.baseBackgroundColor = .mainColorNadaMain
                    button.configuration?.baseForegroundColor = .white
                }
            }
            completeButton.configurationUpdateHandler = configHandler
        } else {
            // TODO: - QA/iOS 13 테스트. selected 설정.
            completeButton.layer.cornerRadius = 15
            
        completeButton.setTitle("완료", for: .normal)
            completeButton.setTitleColor(.white, for: .normal)
        completeButton.setBackgroundImage(UIImage(named: "enableButtonBackground"), for: .normal)
        
        completeButton.setTitle("완료", for: .disabled)
        completeButton.setTitleColor(.white, for: .disabled)
        completeButton.setBackgroundImage(UIImage(named: "disableButtonBackground"), for: .disabled)
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
    private func checkEditingMode() {
        
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func dragToBack() {
        let indexPath = IndexPath(item: 1, section: 0)
        cardCreationCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        if currentIndex == 0 {
            UIView.animate(withDuration: 0.3) {
                self.statusMovedView.transform = CGAffineTransform(translationX: self.backTextLabel.frame.origin.x - self.statusMovedView.frame.origin.x - 5, y: 0)
            }
            currentIndex = 1
             self.frontTextLabel.textColor = .quaternary
             self.backTextLabel.textColor = .secondary
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
             self.frontTextLabel.textColor = .secondary
             self.backTextLabel.textColor = .quaternary
        }
    }
}

// MARK: - Network
extension CardCreationViewController {
    // TODO: - card 서버통신. 위치변경.
//    func cardDetailFetchWithAPI(cardID: String) {
//        CardAPI.shared.cardDetailFetch(cardID: cardID) { response in
//            switch response {
//            case .success(let data):
//                if let card = data as? Card {
//                    self.cardData = card
//                }
//            case .requestErr(let message):
//                print("cardDetailFetchWithAPI - requestErr: \(message)")
//            case .pathErr:
//                print("cardDetailFetchWithAPI - pathErr")
//            case .serverErr:
//                print("cardDetailFetchWithAPI - serverErr")
//            case .networkFail:
//                print("cardDetailFetchWithAPI - networkFail")
//            }
//        }
//    }

    // TODO: - group 서버통신. 위치변경.
//    func changeGroupWithAPI(request: ChangeGroupRequest) {
//        GroupAPI.shared.changeCardGroup(request: request) { response in
//            switch response {
//            case .success:
//                print("changeGroupWithAPI - success")
//            case .requestErr(let message):
//                print("changeGroupWithAPI - requestErr: \(message)")
//            case .pathErr:
//                print("changeGroupWithAPI - pathErr")
//            case .serverErr:
//                print("changeGroupWithAPI - serverErr")
//            case .networkFail:
//                print("changeGroupWithAPI - networkFail")
//            }
//        }
//    }
    // TODO: - group 서버통신. 위치변경.
//    func cardDeleteInGroupWithAPI(groupID: Int, cardID: String) {
//        GroupAPI.shared.cardDeleteInGroup(groupID: groupID, cardID: cardID) { response in
//            switch response {
//            case .success:
//                print("cardDeleteInGroupWithAPI - success")
//            case .requestErr(let message):
//                print("cardDeleteInGroupWithAPI - requestErr: \(message)")
//            case .pathErr:
//                print("cardDeleteInGroupWithAPI - pathErr")
//            case .serverErr:
//                print("cardDeleteInGroupWithAPI - serverErr")
//            case .networkFail:
//                print("cardDeleteInGroupWithAPI - networkFail")
//            }
//
//        }
//    }
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
             self.frontTextLabel.textColor = .quaternary
             self.backTextLabel.textColor = .primary
        } else if targetIndex == 0 && currentIndex == 1 {
            UIView.animate(withDuration: 0.2) {
                self.statusMovedView.transform = .identity
            }
            currentIndex = 0
             self.frontTextLabel.textColor = .primary
             self.backTextLabel.textColor = .quaternary
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
                frontCreationCell.presentingBirthBottomVCClosure = {
                    let nextVC = SelectBirthBottomSheetViewController()
                                .setTitle("생년월일")
                                .setHeight(355)
                    nextVC.modalPresentationStyle = .overFullScreen
                    self.present(nextVC, animated: false, completion: nil)
                }
                frontCreationCell.presentingMBTIBottomVCClosure = {
                    let nextVC = SelectMBTIBottmViewController()
                                .setTitle("MBTI")
                                .setHeight(355)
                    nextVC.modalPresentationStyle = .overFullScreen
                    self.present(nextVC, animated: false, completion: nil)
                }
                
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

// MARK: - FrontCardCreationDelegate

extension CardCreationViewController: FrontCardCreationDelegate {
    func frontCardCreation(requiredInfo valid: Bool) {
        frontCardRequiredIsEmpty = !valid
        if frontCardRequiredIsEmpty == false && backCardRequiredIsEmpty == false {
            completeButtonIsEnabled = .enable
        } else {
            completeButtonIsEnabled = .disable
        }
    }
    func frontCardCreation(endEditing valid: Bool) {
        isEditingMode = valid
    }
    func frontCardCreation(withRequired requiredInfo: [String: String], withOptional optionalInfo: [String: String]) {
        frontCard = FrontCardDataModel(defaultImage: Int(requiredInfo["defaultImage"] ?? "0") ?? 0,
                                       title: requiredInfo["title"]  ?? "",
                                       name: requiredInfo["name"] ?? "",
                                       birthDate: requiredInfo["birthDate"] ?? "",
                                       mbti: requiredInfo["mbti"] ?? "",
                                       instagramID: optionalInfo["instagram"] ?? "",
                                       linkURL: optionalInfo["linkURL"] ?? "",
                                       description: optionalInfo["description"] ?? "")
    }
}

// MARK: - BackCardCreationDelegate

extension CardCreationViewController: BackCardCreationDelegate {
    func backCardCreation(requiredInfo valid: Bool) {
        backCardRequiredIsEmpty = !valid
        if frontCardRequiredIsEmpty == false && backCardRequiredIsEmpty == false {
            completeButtonIsEnabled = .enable
        } else {
            completeButtonIsEnabled = .disable
        }
    }
    func backCardCreation(endEditing valid: Bool) {
        isEditingMode = valid
    }
    func backCardCreation(withRequired requiredInfo: [String: Bool], withOptional optionalInfo: [String: String]) {
        backCard = BackCardDataModel(isMincho: requiredInfo["isMincho"] ?? false,
                                     isSoju: requiredInfo["isSoju"] ?? false,
                                     isBoomuk: requiredInfo["isBoomuk"] ?? false,
                                     isSauced: requiredInfo["isSauced"] ?? false,
                                     firstTMI: optionalInfo["firstTMI"] ?? "",
                                     secondTMI: optionalInfo["secondTMI"] ?? "",
                                     thirdTMI: optionalInfo["thirdTMI"] ?? "")
    }
}
