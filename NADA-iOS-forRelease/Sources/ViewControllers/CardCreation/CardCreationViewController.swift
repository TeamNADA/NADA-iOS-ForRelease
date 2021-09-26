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
        creationTextLabel.text = "명함 생성"
        creationTextLabel.font = UIFont(name: "AppleSDGothicNeo-ExtraBold", size: 26)
        creationTextLabel.textColor = .white
        
        frontTextLabel.text = "앞면"
        frontTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        frontTextLabel.textColor = .white
        
        backTextLabel.text = "뒷면"
        backTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        backTextLabel.textColor = .white
        
//        closeButton
        
        completeButton.setTitle("다음", for: .normal)
        completeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
    }
    private func registerCell() {
        textStatusCollectionView.delegate = self
        cardCreationCollectionView.delegate = self
        textStatusCollectionView.dataSource = self
        cardCreationCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate

extension CardCreationViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension CardCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CardCreationViewController: UICollectionViewDelegateFlowLayout {
    
}
