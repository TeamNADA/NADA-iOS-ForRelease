//
//  TabBarViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let appearance = UITabBarAppearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
    }
    
    func setupStyle() {
//        appearance.configureWithOpaqueBackground()
//        appearance.shadowColor = UIColor.clear
//        tabBar.standardAppearance = appearance
//
//        if #available(iOS 15.0, *) {
//            // set tabbar opacity
//            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//        }
//
//        // set tabbar shadow
//        tabBar.layer.masksToBounds = false
//        tabBar.layer.shadowColor = UIColor.textBox.cgColor
//        tabBar.layer.shadowOpacity = 0.3
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        tabBar.layer.shadowRadius = 6
    }
}
