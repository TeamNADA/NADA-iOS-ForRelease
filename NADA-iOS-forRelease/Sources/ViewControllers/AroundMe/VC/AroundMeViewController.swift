//
//  AroundMeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/28.
//

import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then
import UIKit

final class AroundMeViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let navigationBar = CustomNavigationBar()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }

}

extension AroundMeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        navigationBar.setUI("내 근처의 명함", leftImage: UIImage(named: "iconClear"), rightImage: UIImage(named: "iconRefreshLocation"))
        navigationBar.leftButtonAction = {
          self.dismiss(animated: true)
        }
        navigationBar.rightButtonAction = {
          print("리프레시")
        }
    }
    
    private func setLayout() {
        view.addSubviews([navigationBar])
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
}
