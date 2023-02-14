//
//  HomeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/06.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let giveCardImageView = UIImageView().then {
        $0.image = UIImage(named: "cardVertical")
    }
    
    private let takeCardImageView = UIImageView().then {
        $0.image = UIImage(named: "cardVertical")
    }
    
    private let aroundMeImageView = UIImageView().then {
        $0.image = UIImage(named: "cardVertical")
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension HomeViewController {
    
    // MARK: - UI & Layout
    
    // MARK: - Methods
}
