//
//  CardCreationViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit

class CardCreationViewController: UIViewController {

    // MARK: - Properties
    
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
        
        creationTextLabel.text = "명함 생성"
        creationTextLabel.font = UIFont(name: "AppleSDGothicNeo-ExtraBold", size: 26)
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
        completeButton.setTitleColor(.gray, for: .normal)
        completeButton.backgroundColor = .darkGray
        
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
        
        let frontCardCreationCell = UINib(nibName: FrontCardCreationCell.identifier, bundle: nil)
        let backCardCreationCell = UINib(nibName: BackCardCreationCell.identifier, bundle: nil)
        cardCreationCollectionView.register(frontCardCreationCell, forCellWithReuseIdentifier: FrontCardCreationCell.identifier)
        cardCreationCollectionView.register(backCardCreationCell, forCellWithReuseIdentifier: BackCardCreationCell.identifier)
    }
}

// MARK: - UICollectionViewDelegate

extension CardCreationViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension CardCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cardCreationCollectionView {
            if indexPath.row == 0 {
                guard let frontCreationCell = collectionView.dequeueReusableCell(withReuseIdentifier: FrontCardCreationCell.identifier, for: indexPath) as? FrontCardCreationCell else {
                    return UICollectionViewCell()
                }
                return frontCreationCell
            } else if indexPath.row == 1 {
                guard let backCreationCell = collectionView.dequeueReusableCell(withReuseIdentifier: BackCardCreationCell.identifier, for: indexPath) as? BackCardCreationCell else {
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
