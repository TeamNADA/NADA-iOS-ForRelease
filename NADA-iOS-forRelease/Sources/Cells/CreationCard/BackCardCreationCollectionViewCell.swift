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
    private var optionalInfoList = [UITextField]()
    
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
    
    @IBOutlet weak var requiredCollectionView: UICollectionView!
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        registerCell()
        textFieldDelegate()
    }
}

extension BackCardCreationCollectionViewCell {
    private func setUI() {
        initUITextFieldList()
        scrollView.indicatorStyle = .white
        scrollView.backgroundColor = .black1
        bgView.backgroundColor = .black1
        requiredCollectionView.backgroundColor = .stepBlack5
        requiredInfoView.backgroundColor = .stepBlack5
        optionInfoView.backgroundColor = .stepBlack5
        
        requiredInfoTextLabel.text = "1 필수 정보"
        requiredInfoTextLabel.font = .step
        requiredInfoTextLabel.textColor = .white1
        
        optionalInfoTextLabel.text = "2 선택 정보"
        optionalInfoTextLabel.font = .step
        optionalInfoTextLabel.textColor = .white1
        
        firstQuestionTextField.attributedPlaceholder = NSAttributedString(string: "질문 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.hintGray1])
        firstAnswerTextField.attributedPlaceholder = NSAttributedString(string: "대답 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.hintGray1])
        secondQuestionTextField.attributedPlaceholder = NSAttributedString(string: "질문 2", attributes: [NSAttributedString.Key.foregroundColor: UIColor.hintGray1])
        secondAnswerTextField.attributedPlaceholder = NSAttributedString(string: "대답 2", attributes: [NSAttributedString.Key.foregroundColor: UIColor.hintGray1])
        
        _ = optionalInfoList.map {
            $0.font = .hint
            $0.backgroundColor = .inputBlack2
            $0.textColor = .white1
            $0.layer.cornerRadius = 5
        }
    }
    private func initUITextFieldList() {
        optionalInfoList.append(contentsOf: [firstQuestionTextField,
                                             firstAnswerTextField,
                                             secondQuestionTextField,
                                             secondAnswerTextField])
    }
    private func registerCell() {
        requiredCollectionView.delegate = self
        requiredCollectionView.dataSource = self
        requiredCollectionView.register(RequiredFlavorCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.requiredCollectionViewCell)
    }
    private func textFieldDelegate() {
        _ = optionalInfoList.map { $0.delegate = self }
    }
    static func nib() -> UINib {
        return UINib(nibName: "BackCardCreationCollectionViewCell", bundle: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension BackCardCreationCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource

extension BackCardCreationCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flavorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.requiredCollectionViewCell, for: indexPath) as? RequiredFlavorCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.initCell(flavor: flavorList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BackCardCreationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 13) / 2
        let height = (collectionView.frame.height - 36) / 4
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UITextFieldDelegate

extension BackCardCreationCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.borderWidth = 1
        textField.borderColor = .white1
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderWidth = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
