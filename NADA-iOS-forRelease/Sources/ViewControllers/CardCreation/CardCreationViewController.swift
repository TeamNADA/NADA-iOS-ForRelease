//
//  CardCreationViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit
import KakaoSDKCommon

class CardCreationViewController: UIViewController {

    // MARK: - Properties
    
    private var frontCardIsEmpty = true
    private var backCardIsEmpty = true
    private var restoreFrameYValue = 0.0
    private var currentIndex = 0
    private var cardData: Card?
    
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
        setNotification()
        touchViewToDownKeyboard()
        initRestoreFrameYValue()
        setTextLabelGesture()
        
        // TODO: 서버통신 테스트 중. 추후 호출 위치 변경.
//        getCardDetailFetchWithAPI(cardID: "cardA")
        let cardCreationRequest = CardCreationRequest(userID: "hyungyu", defaultImage: 0, title: "명함 이름", name: "개빡쳐하는 오야옹~", birthDate: "1999/05/12", mbti: "ENFP", instagram: "yaeoni", linkName: "예원깃헓", link: "github.com/yaeoni", description: "NADA의 짱귀염둥이 ㅎ 막이래~", isMincho: false, isSoju: true, isBoomuk: false, isSauced: true, oneQuestion: "테스트용이라", oneAnswer: "모든 정보 다 넣음", twoQuestion: "홀리몰리", twoAnswer: "루삥뽕")
        postCardCreationWithAPI(request: cardCreationRequest, image: UIImage(systemName: "circle")!)
    }
    
    // MARK: - @IBAction Properties

    @IBAction func dismissToPreviousView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pushToCardCompletionView(_ sender: Any) {
        // CardCompletionView 화면전환
    }
}

// MARK: - Extensions

extension CardCreationViewController {
    private func setUI() {
        view.backgroundColor = .black1
        statusMovedView.backgroundColor = .white1
        cardCreationCollectionView.backgroundColor = .black1
        cardCreationCollectionView.isPagingEnabled = true
        
        creationTextLabel.text = "명함 생성"
        creationTextLabel.font = .menu
        creationTextLabel.textColor = .white1
        
        frontTextLabel.text = "앞면"
        frontTextLabel.font = .menuSub
        frontTextLabel.textColor = .white1
        
        backTextLabel.text = "뒷면"
        backTextLabel.font = .menuSub
        backTextLabel.textColor = .hintGray1
        
        closeButton.setImage(UIImage(named: "closeBlack"), for: .normal)
        closeButton.setTitle("", for: .normal)
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.titleLabel?.font = .btn
        completeButton.setTitleColor(.hintGray1, for: .normal)
        completeButton.backgroundColor = .inputBlack2
        completeButton.layer.cornerRadius = 10
        completeButton.isUserInteractionEnabled = false
        
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
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setFrontCardIsEmpty(_:)), name: .frontCardtextFieldIsEmpty, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setbackCardIsEmpty(_:)), name: .backCardtextFieldIsEmpty, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func touchViewToDownKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    private func initRestoreFrameYValue() {
        restoreFrameYValue = self.view.frame.origin.y
    }
    private func setTextLabelGesture() {
        let tapFrontTextLabelGesture = UITapGestureRecognizer(target: self, action: #selector(dragToFront))
        frontTextLabel.addGestureRecognizer(tapFrontTextLabelGesture)
        frontTextLabel.isUserInteractionEnabled = true
        let tapBackTextLabelGesture = UITapGestureRecognizer(target: self, action: #selector(dragToBack))
        backTextLabel.addGestureRecognizer(tapBackTextLabelGesture)
        backTextLabel.isUserInteractionEnabled = true
    }
    @objc
    private func setFrontCardIsEmpty(_ notification: Notification) {
        if let isEmpty = notification.object as? Bool {
            frontCardIsEmpty = isEmpty
        }
//        if frontCardIsEmpty == true && backCardIsEmpty == true {
        if frontCardIsEmpty == true {
            completeButton.backgroundColor = .inputBlack2
            completeButton.setTitleColor(.hintGray1, for: .normal)
            completeButton.isUserInteractionEnabled = false
        } else {
            completeButton.backgroundColor = .mainBlue
            completeButton.setTitleColor(.white1, for: .normal)
            completeButton.isUserInteractionEnabled = true
        }
    }
    @objc
    func setbackCardIsEmpty(_ notification: Notification) {
        if let isEmpty = notification.object as? Bool {
            backCardIsEmpty = isEmpty
        }
        print("backCardIsEmpty : \(backCardIsEmpty)")
    }
    @objc
    func showKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y == restoreFrameYValue {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    @objc
    private func hideKeyboard(_ notification: Notification) {
        if self.view.frame.origin.y != restoreFrameYValue {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y += keyboardHeight
            }
        }
    }
    @objc
    private func dragToBack() {
        let indexPath = IndexPath(item: 1, section: 0)
        cardCreationCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        if currentIndex == 0 {
            UIView.animate(withDuration: 0.3) {
                self.statusMovedView.transform = CGAffineTransform(translationX: self.backTextLabel.frame.origin.x - self.statusMovedView.frame.origin.x + 5, y: 0)
            }
            currentIndex = 1
            self.frontTextLabel.textColor = .hintGray1
            self.backTextLabel.textColor = .white1
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
            self.frontTextLabel.textColor = .white1
            self.backTextLabel.textColor = .hintGray1
        }
    }
}

// MARK: - Network

extension CardCreationViewController {
    func getCardDetailFetchWithAPI(cardID: String) {
        CardAPI.shared.getCardDetailFetch(cardID: cardID) { response in
            switch response {
            case .success(let data):
                if let card = data as? Card {
                    self.cardData = card
                }
            case .requestErr(let message):
                print("getCardDetailFetchWithAPI - requestErr", message)
            case .pathErr:
                print("getCardDetailFetchWithAPI - pathErr")
            case .serverErr:
                print("getCardDetailFetchWithAPI - serverErr")
            case .networkFail:
                print("getCardDetailFetchWithAPI - networkFail")
            }
        }
    }
    func postCardCreationWithAPI(request: CardCreationRequest, image: UIImage) {
        CardAPI.shared.postCardCreation(request: request, image: image) { response in
            switch response {
            case .success(_):
                print("postCardCreationWithAPI - success")
            case .requestErr(let message):
                print("postCardCreationWithAPI - requestErr", message)
            case .pathErr:
                print("postCardCreationWithAPI - pathErr")
            case .serverErr:
                print("postCardCreationWithAPI - serverErr")
            case .networkFail:
                print("postCardCreationWithAPI - networkFail")
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
            self.frontTextLabel.textColor = .hintGray1
            self.backTextLabel.textColor = .white
        } else if targetIndex == 0 && currentIndex == 1 {
            UIView.animate(withDuration: 0.2) {
                self.statusMovedView.transform = .identity
            }
            currentIndex = 0
            self.frontTextLabel.textColor = .white1
            self.backTextLabel.textColor = .hintGray1
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
            if indexPath.row == 0 {
                guard let frontCreationCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.frontCardCreationCollectionViewCell, for: indexPath) as? FrontCardCreationCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return frontCreationCell
            } else if indexPath.row == 1 {
                guard let backCreationCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.backCardCreationCollectionViewCell, for: indexPath) as? BackCardCreationCollectionViewCell else {
                    return UICollectionViewCell()
                }
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
