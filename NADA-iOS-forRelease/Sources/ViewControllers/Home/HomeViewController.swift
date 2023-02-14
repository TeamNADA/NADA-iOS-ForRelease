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
    private let nadaIcon = UIImageView().then {
        $0.image = UIImage(named: "nadaLogoTxt")
    }
    private let giveCardImageView = UIImageView().then {
        $0.image = UIImage(named: "cardVertical")
    }
    private let takeCardImageView = UIImageView().then {
        $0.image = UIImage(named: "cardVertical")
    }
    private let aroundMeImageView = UIImageView().then {
        $0.image = UIImage(named: "cardVertical")
    }
    private let giveCardLabel = UILabel().then {
        $0.text = "명함 주기"
    }
    private let takeCardLabel = UILabel().then {
        $0.text = "명함 받기"
    }
    private let aroundMeLabel = UILabel().then {
        $0.text = "내 근처의 명함"
    }
    private let giveCardIcon = UIImageView().then {
        $0.backgroundColor = .blue
    }
    private let takeCardIcon = UIImageView().then {
        $0.backgroundColor = .blue
    }
    private let aroundMeIcon = UIImageView().then {
        $0.backgroundColor = .blue
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

}

extension HomeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Methods
}
