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
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

}

extension AroundMeViewController {
    
    // MARK: - UI & Layout
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
}
