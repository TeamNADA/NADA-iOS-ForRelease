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
    }
}

extension BackCardCreationCollectionViewCell {
    private func setUI() {
        initUITextFieldList()
        //        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .black
        bgView.backgroundColor = .black
        requiredCollectionView.backgroundColor = .gray
        requiredInfoView.backgroundColor = .gray
        optionInfoView.backgroundColor = .gray
        
        requiredInfoTextLabel.text = "1 필수 정보"
        requiredInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        requiredInfoTextLabel.textColor = .white
        
        optionalInfoTextLabel.text = "2 선택 정보"
        optionalInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        optionalInfoTextLabel.textColor = .white
        
        firstQuestionTextField.attributedPlaceholder = NSAttributedString(string: "질문 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        firstAnswerTextField.attributedPlaceholder = NSAttributedString(string: "대답 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        secondQuestionTextField.attributedPlaceholder = NSAttributedString(string: "질문 2", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        secondAnswerTextField.attributedPlaceholder = NSAttributedString(string: "대답 2", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        
        _ = optionalInfoList.map {
            $0.backgroundColor = .systemGray2
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
    static func nib() -> UINib {
        return UINib(nibName: "BackCardCreationCollectionViewCell", bundle: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension BackCardCreationCollectionViewCell: UICollectionViewDelegate {
    
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
