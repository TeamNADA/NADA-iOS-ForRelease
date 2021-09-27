//
//  BackCardCreationCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit

class BackCardCreationCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "BackCardCreationCell"
    var flavorList = ["민초", "반민초", "소주", "맥주", "부먹", "찍먹", "양념", "후라이드"]
    
    // MARK: - @IBOutlet Properties
    
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

extension BackCardCreationCell {
    private func setUI() {
//        scrollView.showsVerticalScrollIndicator = false
        
        requiredInfoTextLabel.text = "1 필수 정보"
        requiredInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        optionalInfoTextLabel.text = "2 선택 정보"
        optionalInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        
        firstQuestionTextField.placeholder = "질문 1"
        firstQuestionTextField.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        firstAnswerTextField.placeholder = "대답 1"
        firstAnswerTextField.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        secondQuestionTextField.placeholder = "질문 2"
        secondQuestionTextField.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        secondAnswerTextField.placeholder = "대답 2"
        secondAnswerTextField.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
    }
    private func registerCell() {
        requiredCollectionView.delegate = self
        requiredCollectionView.dataSource = self
        let cell = UINib(nibName: RequiredFlavorCell.identifier, bundle: nil)
        requiredCollectionView.register(cell, forCellWithReuseIdentifier: RequiredFlavorCell.identifier)
    }
}

// MARK: - UICollectionViewDelegate

extension BackCardCreationCell: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension BackCardCreationCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flavorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RequiredFlavorCell.identifier, for: indexPath) as? RequiredFlavorCell else {
            return UICollectionViewCell()
        }
        cell.initCell(flavor: flavorList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BackCardCreationCell: UICollectionViewDelegateFlowLayout {
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
