//
//  BackCardCreationCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit

import FirebaseAnalytics
import IQKeyboardManagerSwift

class BackCardCreationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "BackCardCreationCollectionViewCell"
    
    public var cardType: CardType?
    public var flavorList: [String]?
    private let maxLength: Int = 140
    private var requiredCollectionViewList = [UICollectionView]()
    
    public weak var backCardCreationDelegate: BackCardCreationDelegate?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var requiredInfoTextLabel: UILabel!
    @IBOutlet weak var optionalInfoTextLabel: UILabel!
    
    @IBOutlet weak var tmiTextView: UITextView!
    
    @IBOutlet weak var firstTasteCollectionView: UICollectionView!
    @IBOutlet weak var secondTasteCollectionView: UICollectionView!
    @IBOutlet weak var thirdTasteCollectionView: UICollectionView!
    @IBOutlet weak var fourthTasteCollectionView: UICollectionView!
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        registerCell()
        textViewDelegate()
        setNotification()
    }
}

// MARK: - Extensions

extension BackCardCreationCollectionViewCell {
    private func setUI() {
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        initCollectionViewList()
        
        scrollView.indicatorStyle = .default
        scrollView.backgroundColor = .background
        bgView.backgroundColor = .background
        
        _ = requiredCollectionViewList.map { $0.backgroundColor = .background }
        
        let requiredAttributeString = NSMutableAttributedString(string: "*나의 취향을 골라보세요.")
        requiredAttributeString.addAttribute(.foregroundColor, value: UIColor.mainColorNadaMain, range: NSRange(location: 0, length: 1))
        requiredAttributeString.addAttribute(.foregroundColor, value: UIColor.secondary, range: NSRange(location: 1, length: requiredAttributeString.length - 1))
        requiredInfoTextLabel.attributedText = requiredAttributeString
        requiredInfoTextLabel.font = .textBold01
        
        optionalInfoTextLabel.text = "나의 재밌는 TMI를 알려주세요."
        optionalInfoTextLabel.textColor = .secondary
        optionalInfoTextLabel.font = .textBold01
        
        tmiTextView.tintColor = .primary
        tmiTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tmiTextView.backgroundColor = .textBox
        tmiTextView.font = .textRegular04
        tmiTextView.text = "조금 더 다채로운 모습을 담아볼까요?"
        tmiTextView.textColor = .quaternary
        tmiTextView.layer.cornerRadius = 10
    }
    private func initCollectionViewList() {
        requiredCollectionViewList.append(contentsOf: [
            firstTasteCollectionView,
            secondTasteCollectionView,
            thirdTasteCollectionView,
            fourthTasteCollectionView
        ])
    }
    private func registerCell() {
        _ = requiredCollectionViewList.map {
            $0.delegate = self
            $0.dataSource = self
            $0.register(RequiredFlavorCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.requiredCollectionViewCell)
        }
    }
    private func textViewDelegate() {
        tmiTextView.delegate = self
    }
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyboard), name: .touchRequiredView, object: nil)
    }
    private func checkBackCardStatus() {
        backCardCreationDelegate?.backCardCreation(withRequired: [
            firstTasteCollectionView.indexPathsForSelectedItems == [[0, 0]] ? flavorList?[0] ?? "" : flavorList?[1] ?? "",
            secondTasteCollectionView.indexPathsForSelectedItems == [[0, 0]] ? flavorList?[2] ?? "" : flavorList?[3] ?? "",
            thirdTasteCollectionView.indexPathsForSelectedItems == [[0, 0]] ? flavorList?[4] ?? "" : flavorList?[5] ?? "",
            fourthTasteCollectionView.indexPathsForSelectedItems == [[0, 0]] ? flavorList?[6] ?? "" : flavorList?[7] ?? ""
        ], withOptional: tmiTextView.text == "조금 더 다채로운 모습을 담아볼까요?" ? nil : tmiTextView.text)
    }
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.backCardCreationCollectionViewCell, bundle: Bundle(for: BackCardCreationCollectionViewCell.self))
    }
    
    // MARK: - @objc Methods
    @objc
    private func dismissKeyboard() {
        tmiTextView.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDelegate
extension BackCardCreationCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        backCardCreationDelegate?.backCardCreation(endEditing: true)
        if firstTasteCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            secondTasteCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            thirdTasteCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            fourthTasteCollectionView.indexPathsForSelectedItems?.isEmpty == false {
            backCardCreationDelegate?.backCardCreation(requiredInfo: true)
        } else {
            backCardCreationDelegate?.backCardCreation(requiredInfo: false)
        }
        checkBackCardStatus()
        
        guard let cardType else { return }
        
        switch cardType {
        case .basic:
            Analytics.logEvent(Tracking.Event.touchBasicTasteInfo + (flavorList?[indexPath.item] ?? ""), parameters: nil)
        case .company:
            Analytics.logEvent(Tracking.Event.touchCompanyTasteInfo + (flavorList?[indexPath.item] ?? ""), parameters: nil)
        case .fan:
            Analytics.logEvent(Tracking.Event.touchFanTasteInfo + (flavorList?[indexPath.item] ?? ""), parameters: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BackCardCreationCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.requiredCollectionViewCell, for: indexPath) as? RequiredFlavorCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch collectionView {
        case firstTasteCollectionView:
            cell.initCell(flavor: flavorList?[indexPath.item] ?? "")
        case secondTasteCollectionView:
            cell.initCell(flavor: flavorList?[indexPath.item + 2] ?? "")
        case thirdTasteCollectionView:
            cell.initCell(flavor: flavorList?[indexPath.item + 4] ?? "")
        case fourthTasteCollectionView:
            cell.initCell(flavor: flavorList?[indexPath.item + 6] ?? "")
        default:
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BackCardCreationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 7) / 2
        let cellHeight = collectionView.frame.height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UITextViewDelegate
extension BackCardCreationCollectionViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "조금 더 다채로운 모습을 담아볼까요?" {
            textView.text = ""
            textView.textColor = .primary
        }
        textView.borderColor = .primary
        textView.borderWidth = 1
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "조금 더 다채로운 모습을 담아볼까요?"
            textView.textColor = .quaternary
        }
        backCardCreationDelegate?.backCardCreation(endEditing: true)
        checkBackCardStatus()
        textView.borderWidth = 0
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 140 {
            textView.deleteBackward()
        }
    }
}
