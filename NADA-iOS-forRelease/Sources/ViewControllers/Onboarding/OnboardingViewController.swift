//
//  OnboardingViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/05.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private let onboardingList = ["onboarding01", "onboarding02", "onboarding03", "onboarding04"]
    // TODO: - 🪓 선배륌들 이런 방법도있어서 써봤어여 사이즈같은 쓰이는 숫자들 여기서 다뤄도 좋을거 같아여..
    private enum Size {
        static let cellWidth: CGFloat = 327
        static let cellHeigth: CGFloat = 327
        static let cellTopInset: CGFloat = 198
        static let cellBottomInset: CGFloat = 198
        static let cellLineSpacing: CGFloat = 30
    }
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        collectionViewDelegate()
    }
}

// MARK: - Extensions

extension OnboardingViewController {
    private func setUI() {
        let collectionViewLayout = onboardingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.estimatedItemSize = .zero
        collectionViewLayout?.scrollDirection = .vertical
        onboardingCollectionView.showsVerticalScrollIndicator = false
        onboardingCollectionView.isPagingEnabled = true
    }
    private func collectionViewDelegate() {
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        
        onboardingCollectionView.register(OnboardingCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.onboardingCollectionViewCell)
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.onboardingCollectionViewCell, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
        let isLast = indexPath.item == 3 ? true : false
        cell.initCell(image: onboardingList[indexPath.item], isLast: isLast)
        
        if isLast {
            cell.presentToLoginViewController = {
                guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.loginViewController) as? LoginViewController else { return }
                nextVC.modalTransitionStyle = .crossDissolve
                nextVC.modalPresentationStyle = .fullScreen
                
                self.present(nextVC, animated: true, completion: nil)
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Size.cellLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Size.cellTopInset, left: 0, bottom: Size.cellBottomInset, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Size.cellWidth, height: Size.cellHeigth)
    }

}
