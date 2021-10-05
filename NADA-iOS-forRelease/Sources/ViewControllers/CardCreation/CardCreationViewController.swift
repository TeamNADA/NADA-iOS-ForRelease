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
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var creationTextLabel: UILabel!
    @IBOutlet weak var frontTextLabel: UILabel!
    @IBOutlet weak var backTextLabel: UILabel!
    @IBOutlet weak var textStatusCollectionView: UICollectionView!
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
        view.backgroundColor = .black
        cardCreationCollectionView.backgroundColor = .black
        cardCreationCollectionView.isPagingEnabled = true
        
        creationTextLabel.text = "명함 생성"
        creationTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26)
        creationTextLabel.textColor = .white
        
        frontTextLabel.text = "앞면"
        frontTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        frontTextLabel.textColor = .white
        
        backTextLabel.text = "뒷면"
        backTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        backTextLabel.textColor = .white
        
        closeButton.setImage(UIImage(named: "closeBlack24Dp"), for: .normal)
        closeButton.setTitle("", for: .normal)
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        completeButton.setTitleColor(Colors.hint.color, for: .normal)
        completeButton.backgroundColor = Colors.inputBlack.color
        completeButton.layer.cornerRadius = 10
        completeButton.isUserInteractionEnabled = false
        
        let cardCreationCollectionViewlayout = cardCreationCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        cardCreationCollectionViewlayout?.scrollDirection = .horizontal
        cardCreationCollectionViewlayout?.estimatedItemSize = .zero
        cardCreationCollectionView.showsHorizontalScrollIndicator = false
        cardCreationCollectionView.showsVerticalScrollIndicator = false
    }
    private func registerCell() {
//        let textStatusCollectionViewlayout = textStatusCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        textStatusCollectionViewlayout?.scrollDirection = .horizontal
//        textStatusCollectionView.delegate = self
//        textStatusCollectionView.dataSource = self
        
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
    @objc
    private func setFrontCardIsEmpty(_ notification: Notification) {
        if let isEmpty = notification.object as? Bool {
            frontCardIsEmpty = isEmpty
        }
//        if frontCardIsEmpty == true && backCardIsEmpty == true {
        if frontCardIsEmpty == true {
            completeButton.backgroundColor = Colors.inputBlack.color
            completeButton.setTitleColor(Colors.hint.color, for: .normal)
            completeButton.isUserInteractionEnabled = false
        } else {
            completeButton.backgroundColor = Colors.mainBlue.color
            completeButton.setTitleColor(Colors.white.color, for: .normal)
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
}

// MARK: - UICollectionViewDelegate

extension CardCreationViewController: UICollectionViewDelegate { }

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
