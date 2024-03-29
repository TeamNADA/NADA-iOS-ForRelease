//
//  ModuleFactory.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/03/12.
//

import UIKit

/*
 - 사용법:
 1) ModuelFactoryProtocol에 넘겨야할 VC를 메서드 형태로 정의만 한다.
 
 2) ModuleFactory를 extension해서 구현해야 할 부분을 직접 작성한다.
 controllerFromStoryboard(익스텐션)를 활용해서 인스턴스를 생성한다
 -> storyboard를 사용하지 않으면 가져오지 않고 뷰컨 자체를 가지고 오면 된다.
 
 3) 각각 필요한 VC내에서 MoudleFactory를 가지고 뷰컨을 가져오면 끝!
 
 @creds to Song jihun (github: https://github.com/i-colours-u)
 */

protocol ModuleFactoryProtocol {
    func makeSplashVC() -> SplashViewController
    func makeAroundMeVC() -> AroundMeViewController
    func makeUpdateVC() -> UpdateViewController
    func makeCardDetailVC() -> CardDetailViewController
    func makeCardCreationCategoryVC() -> CardCreationCategoryViewController
    func makeGroupEditVC(groupList: [String]) -> GroupEditViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    static let shared = ModuleFactory()
    private init() { }
    
    func makeSplashVC() -> SplashViewController {
        let splashVC = SplashViewController.controllerFromStoryboard(.splash)
        return splashVC
    }
    
    func makeAroundMeVC() -> AroundMeViewController {
        let viewModel = AroundMeViewModel()
        let aroundMeVC = AroundMeViewController()
        aroundMeVC.viewModel = viewModel
        aroundMeVC.modalPresentationStyle = .overFullScreen
        return aroundMeVC
    }
    
    func makeUpdateVC() -> UpdateViewController {
        let updateVC = UpdateViewController()
        updateVC.modalPresentationStyle = .overFullScreen
        updateVC.modalTransitionStyle = .crossDissolve
        return updateVC
    }
    
    func makeCardDetailVC() -> CardDetailViewController {
        let cardDetailVC = CardDetailViewController.controllerFromStoryboard(.cardDetail)
        cardDetailVC.modalPresentationStyle = .overFullScreen
        return cardDetailVC
    }
    
    func makeGroupEditVC(groupList: [String]) -> GroupEditViewController {
        let viewModel = GroupEditViewModel(groupList: groupList)
        let groupEditVC = GroupEditViewController.controllerFromStoryboard(.groupEdit)
        groupEditVC.viewModel = viewModel
        return groupEditVC
    }
    
    func makeCardCreationCategoryVC() -> CardCreationCategoryViewController {
        let cardCreationCategoryVC = CardCreationCategoryViewController()
        return cardCreationCategoryVC
    }
    
    func makeCardCreationVC(cardType: CardType, preCardDataModel: Card? = nil) -> UINavigationController {
        let cardCreationVC: UIViewController
        
        switch cardType {
        case .basic:
            let basicCardCreationVC = CardCreationViewController.controllerFromStoryboard(.cardCreation)
            
            if let preCardDataModel {
                basicCardCreationVC.setPreCardDataModel(preCardDataModel)
                basicCardCreationVC.setCreationType(.modify)
            }
            
            cardCreationVC = basicCardCreationVC
        case .company:
            let companyCardCreationVC = CompanyCardCreationViewController.controllerFromStoryboard(.companyCardCreation)
            
            if let preCardDataModel {
                companyCardCreationVC.setPreCardDataModel(preCardDataModel)
                companyCardCreationVC.setCreationType(.modify)
            }
            
            cardCreationVC = companyCardCreationVC
        case .fan:
            let fanCardCreationVC = FanCardCreationViewController.controllerFromStoryboard(.fanCardCreation)
            
            if let preCardDataModel {
                fanCardCreationVC.setPreCardDataModel(preCardDataModel)
                fanCardCreationVC.setCreationType(.modify)
            }
            
            cardCreationVC = fanCardCreationVC
        }
        
        let navigationController = UINavigationController(rootViewController: cardCreationVC)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
