//
//  BackCardCreationCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit

class BackCardCreationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "BackCardCreationCollectionViewCell"
    private let flavorList = ["민초", "반민초", "소주", "맥주", "부먹", "찍먹", "양념", "후라이드"]
    private var textFieldList = [UITextField]()
    private var requiredCollectionViewList = [UICollectionView]()
    public weak var backCardCreationDelegate: BackCardCreationDelegate?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var requiredInfoTextLabel: UILabel!
    @IBOutlet weak var optionalInfoTextLabel: UILabel!
    
    @IBOutlet weak var firstTMITextField: UITextField!
    @IBOutlet weak var secondTMITextField: UITextField!
    @IBOutlet weak var thirdTMITextField: UITextField!
    
    @IBOutlet weak var isMinchoCollectionView: UICollectionView!
    @IBOutlet weak var isSojuCollectionView: UICollectionView!
    @IBOutlet weak var isBoomukCollectionView: UICollectionView!
    @IBOutlet weak var isSaucedCollectionView: UICollectionView!
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        registerCell()
        textFieldDelegate()
    }
}

// MARK: - Extensions

extension BackCardCreationCollectionViewCell {
    private func setUI() {
        initUITextFieldList()
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
        
        let optionalAttributeString = NSMutableAttributedString(string: "나의 재밌는 TMI를 알려주세요. (20자)")
        optionalAttributeString.addAttribute(.foregroundColor, value: UIColor.secondary, range: NSRange(location: 0, length: 18))
        optionalAttributeString.addAttribute(.font, value: UIFont.textBold01, range: NSRange(location: 0, length: 18))
        optionalAttributeString.addAttribute(.foregroundColor, value: UIColor.quaternary, range: NSRange(location: 19, length: 5))
        optionalAttributeString.addAttribute(.font, value: UIFont.textRegular03, range: NSRange(location: 19, length: 5))
        optionalInfoTextLabel.attributedText = optionalAttributeString
        
        firstTMITextField.attributedPlaceholder = NSAttributedString(string: "TMI 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.quaternary])
        secondTMITextField.attributedPlaceholder = NSAttributedString(string: "TMI 2", attributes: [NSAttributedString.Key.foregroundColor: UIColor.quaternary])
        thirdTMITextField.attributedPlaceholder = NSAttributedString(string: "TMI 3", attributes: [NSAttributedString.Key.foregroundColor: UIColor.quaternary])
        
        _ = textFieldList.map {
            $0.font = .textRegular04
            $0.backgroundColor = .textBox
            $0.textColor = .primary
            $0.layer.cornerRadius = 10
            $0.borderStyle = .none
            $0.setLeftPaddingPoints(12)
        }
    }
    private func initUITextFieldList() {
        textFieldList.append(contentsOf: [
            firstTMITextField,
            secondTMITextField,
            thirdTMITextField
        ])
    }
    private func initCollectionViewList() {
        requiredCollectionViewList.append(contentsOf: [
            isMinchoCollectionView,
            isSojuCollectionView,
            isBoomukCollectionView,
            isSaucedCollectionView
        ])
    }
    private func registerCell() {
        _ = requiredCollectionViewList.map {
            $0.delegate = self
            $0.dataSource = self
            $0.register(RequiredFlavorCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.requiredCollectionViewCell)
        }
    }
    private func textFieldDelegate() {
        _ = textFieldList.map { $0.delegate = self }
    }
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.backCardCreationCollectionViewCell, bundle: Bundle(for: BackCardCreationCollectionViewCell.self))
    }
}

// MARK: - UICollectionViewDelegate
extension BackCardCreationCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        backCardCreationDelegate?.backCardCreation(endEditing: true)
        if isMinchoCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            isSojuCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            isBoomukCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            isSaucedCollectionView.indexPathsForSelectedItems?.isEmpty == false {
            backCardCreationDelegate?.backCardCreation(requiredInfo: true)
            backCardCreationDelegate?.backCardCreation(withRequired: [
                "isMincho": isMinchoCollectionView.indexPathsForSelectedItems == [[0, 0]] ? true: false,
                "isSoju": isSojuCollectionView.indexPathsForSelectedItems == [[0, 0]] ? true: false,
                "isBoomuk": isBoomukCollectionView.indexPathsForSelectedItems == [[0, 0]] ? true: false,
                "isSauced": isSaucedCollectionView.indexPathsForSelectedItems == [[0, 0]] ? true: false
            ], withOptional: [
                "firstTMI": firstTMITextField.text ?? "",
                "secondTMI": secondTMITextField.text ?? "",
                "thirdTMI": thirdTMITextField.text ?? ""
            ])
        } else {
            backCardCreationDelegate?.backCardCreation(requiredInfo: false)
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
        case isMinchoCollectionView:
            cell.initCell(flavor: flavorList[indexPath.item])
        case isSojuCollectionView:
            cell.initCell(flavor: flavorList[indexPath.item + 2])
        case isBoomukCollectionView:
            cell.initCell(flavor: flavorList[indexPath.item + 4])
        case isSaucedCollectionView:
            cell.initCell(flavor: flavorList[indexPath.item + 6])
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

// MARK: - UITextFieldDelegate
extension BackCardCreationCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.borderWidth = 1
        textField.borderColor = .tertiary
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        backCardCreationDelegate?.backCardCreation(endEditing: true)
        textField.borderWidth = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
