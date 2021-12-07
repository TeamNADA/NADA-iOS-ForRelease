//
//  OnboardingViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/05.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private var currentIndex: CGFloat = 0
    private let onboardingList = ["onboarding01", "onboarding02", "onboarding03", "onboarding04"]
    // TODO: - 🪓 선배륌들 이런 방법도있어서 써봤어여 사이즈같은 쓰이는 숫자들 여기서 다뤄도 좋을거 같아여..
    private enum Size {
        static let cellWidth: CGFloat = 327
        static let cellHeigth: CGFloat = 327
        static let cellTopInset: CGFloat = 198
        static let cellBottomInset: CGFloat = 208
        // TODO: - 나커톤 때 라이브코딩 쇼쇼쇼
        static let cellLineSpacing: CGFloat = 85
        // TODO: - 기기대응응 필요.
        static let topSafeArea: CGFloat = 44
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
    }
    private func collectionViewDelegate() {
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        
        onboardingCollectionView.register(OnboardingCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.onboardingCollectionViewCell)
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

//        print(scrollView.contentOffset.y)
//        print(targetContentOffset.pointee.y)
//        print(scrollView.frame.height)
        
//        if scrollView.contentOffset.y > 0 {
//            if scrollView.contentOffset.y <= targetContentOffset.pointee.y {
//                if currentIndex < 3 {
//                    currentIndex += 1
//                    print(currentIndex)
//                }
//            } else {
//                if currentIndex > 0 {
//                    currentIndex -= 1
//                    print(currentIndex)
//                }
//            }
//            let offset = CGPoint(x: 0, y: currentIndex * ( Size.cellHeigth + Size.cellLineSpacing - Size.topSafeArea))
//            targetContentOffset.pointee = offset
//        }
        guard let cv = scrollView as? UICollectionView else { return }
        guard let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//        let cellHeight = layout.itemSize.height + layout.minimumLineSpacing
        
        print(scrollView.contentOffset.y)
        var offset = targetContentOffset.pointee
        let index = round((offset.y) / ( Size.cellHeigth + Size.cellLineSpacing))
        
        if index > currentIndex {
            currentIndex += 1
        } else if index < currentIndex {
            if currentIndex != 0 {
                currentIndex -= 1
            }
        }
        
        if currentIndex == 0 {
            offset = CGPoint(x: CGFloat.zero, y: -Size.topSafeArea)
        } else {
            offset = CGPoint(x: CGFloat.zero, y: currentIndex * (Size.cellHeigth + Size.cellLineSpacing) - Size.topSafeArea)
        }

        targetContentOffset.pointee = offset
    }
}

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
