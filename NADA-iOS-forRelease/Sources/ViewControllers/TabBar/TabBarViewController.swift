//
//  TabBarViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    private let borderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .textBox
        
        return view
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        tabBar.addSubview(borderLineView)
        
        setupLayout()
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        borderLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            borderLineView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            borderLineView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            borderLineView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            borderLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}
