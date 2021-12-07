//
//  TabBarViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // let appearance = UITabBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        self.tabBarController?.tabBar.layer.borderWidth = 1
        self.tabBarController?.tabBar.layer.borderColor = UIColor.textBox.cgColor
        // self.tabBarController?.tabBar.clipsToBounds = false
//        // set tabbar opacity
//        appearance.configureWithOpaqueBackground()
//
//        // remove tabbar border line
//        appearance.shadowColor = UIColor.clear
//
//        // set tabbar background color
//        appearance.backgroundColor = .background
//
//        tabBar.standardAppearance = appearance
//
//        // 없으면 iOS15.0 부터는 탭바에 닿기전에는 탭바가 구분되지 않음(이것도 좀 신기해서 이쁘긴함 ㅋㅋ)
//        if #available(iOS 15.0, *) {
//            // set tabbar opacity
//            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
//        }
//
//        // set tabbar shadow
//        tabBar.layer.masksToBounds = false
//        tabBar.layer.shadowColor = UIColor.textBox.cgColor
//        tabBar.layer.shadowOpacity = 0.5
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        tabBar.layer.shadowRadius = 1
    }
}
