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
    
    @IBOutlet weak var optionInfoView: UIView!
    @IBOutlet weak var requiredInfoView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var requiredInfoTextLabel: UILabel!
    @IBOutlet weak var optionalInfoTextLabel: UILabel!
    
    @IBOutlet weak var firstQuestionTextField: UITextField!
    @IBOutlet weak var firstAnswerTextField: UITextField!
    @IBOutlet weak var secondQuestionTextField: UITextField!
    @IBOutlet weak var secondAnswerTextField: UITextField!
    
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
        
        scrollView.indicatorStyle = .white
        // scrollView.backgroundColor = .black1
        
        // bgView.backgroundColor = .black1
        
        // _ = requiredCollectionViewList.map { $0.backgroundColor = .stepBlack5 }
        
        // requiredInfoView.backgroundColor = .stepBlack5
        
        // optionInfoView.backgroundColor = .stepBlack5
        
        requiredInfoTextLabel.text = "1 필수 정보"
        // requiredInfoTextLabel.font = .step
        // requiredInfoTextLabel.textColor = .white1
        
        optionalInfoTextLabel.text = "2 선택 정보"
        // optionalInfoTextLabel.font = .step
        // optionalInfoTextLabel.textColor = .white1
        
        // firstQuestionTextField.attributedPlaceholder = NSAttributedString(string: "질문 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.hintGray1])
        // firstAnswerTextField.attributedPlaceholder = NSAttributedString(string: "대답 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.hintGray1])
        // secondQuestionTextField.attributedPlaceholder = NSAttributedString(string: "질문 2", attributes: [NSAttributedString.Key.foregroundColor: UIColor.hintGray1])
        // secondAnswerTextField.attributedPlaceholder = NSAttributedString(string: "대답 2", attributes: [NSAttributedString.Key.foregroundColor: UIColor.hintGray1])
        
        _ = textFieldList.map {
            // $0.font = .hint
            // $0.backgroundColor = .inputBlack2
            // $0.textColor = .white1
            $0.layer.cornerRadius = 5
            $0.borderStyle = .none
        }
    }
    private func initUITextFieldList() {
        textFieldList.append(contentsOf: [firstQuestionTextField,
                                             firstAnswerTextField,
                                             secondQuestionTextField,
                                             secondAnswerTextField])
    }
    private func initCollectionViewList() {
        requiredCollectionViewList.append(contentsOf: [isMinchoCollectionView,
                                              isSojuCollectionView,
                                              isBoomukCollectionView,
                                              isSaucedCollectionView])
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
        return UINib(nibName: "BackCardCreationCollectionViewCell", bundle: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension BackCardCreationCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMinchoCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            isSojuCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            isBoomukCollectionView.indexPathsForSelectedItems?.isEmpty == false &&
            isSaucedCollectionView.indexPathsForSelectedItems?.isEmpty == false {
            backCardCreationDelegate?.backCardCreation(requiredInfo: true)
            backCardCreationDelegate?.backCardCreation(withRequired: [
                "isMincho": isMinchoCollectionView.indexPathsForSelectedItems == [[0]] ? true: false,
                "isSoju": isSojuCollectionView.indexPathsForSelectedItems == [[0]] ? true: false,
                "isBoomuk": isBoomukCollectionView.indexPathsForSelectedItems == [[0]] ? true: false,
                "isSauced": isSaucedCollectionView.indexPathsForSelectedItems == [[0]] ? true: false
            ], withOptional: [
                "oneQuestion": firstQuestionTextField.text ?? "",
                "oneAnswer": firstAnswerTextField.text ?? "",
                "twoQuestion": secondQuestionTextField.text ?? "",
                "twoAnswer": secondAnswerTextField.text ?? ""
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
        
        if collectionView == isMinchoCollectionView {
            cell.initCell(flavor: flavorList[indexPath.item])
        } else if collectionView == isSojuCollectionView {
            cell.initCell(flavor: flavorList[indexPath.item + 2])
        } else if collectionView == isBoomukCollectionView {
            cell.initCell(flavor: flavorList[indexPath.item + 4])
        } else {
            cell.initCell(flavor: flavorList[indexPath.item + 6])
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
        return 13
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 13) / 2
        let cellHeight = (collectionView.frame.height)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UITextFieldDelegate
extension BackCardCreationCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.borderWidth = 1
        // textField.borderColor = .white1
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderWidth = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
