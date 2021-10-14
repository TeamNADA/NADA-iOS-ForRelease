//
//  CustomTabBarController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/09.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    // MARK: - Properties
    @IBInspectable public var tintColor: UIColor? {
        didSet {
            customTabBar.tintColor = tintColor
            customTabBar.reloadApperance()
        }
    }
    
    public let customTabBar: CustomTabBar = {
        return CustomTabBar()
    }()
    
    private(set) lazy var smallBottomView: UIView = {
        let anotherSmallView = UIView()
        anotherSmallView.backgroundColor = .clear
        anotherSmallView.translatesAutoresizingMaskIntoConstraints = false

        return anotherSmallView
    }()
    
    override open var selectedIndex: Int {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }

    override open var selectedViewController: UIViewController? {
        didSet {
            customTabBar.select(at: selectedIndex, notifyDelegate: false)
        }
    }
    
    private var bottomSpacing: CGFloat = 5
    private var tabBarHeight: CGFloat = 70
    private var horizontleSpacing: CGFloat = 75
    
    // MARK: - Life Cycles
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight + bottomSpacing, right: 0)

        self.tabBar.isHidden = true

        addAnotherSmallView()
        setupTabBar()
        
        customTabBar.items = tabBar.items!
        customTabBar.select(at: selectedIndex)
        customTabBar.setGradient(color1: UIColor(red: 1, green: 1, blue: 1, alpha: 0.35),
                                 color2: UIColor(red: 1, green: 1, blue: 1, alpha: 0.15))
        customTabBar.setBlur()
    }
    
    // MARK: - Functions
    public func setTabBarHidden(_ isHidden: Bool, animated: Bool) {
        let block = {
            self.customTabBar.alpha = isHidden ? 0 : 1
            self.additionalSafeAreaInsets = isHidden ? .zero : UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarHeight + self.bottomSpacing, right: 0)
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: block)
        } else {
            block()
        }
    }
    
    private func addAnotherSmallView() {
        self.view.addSubview(smallBottomView)
        
        smallBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let cr: NSLayoutConstraint
        
        if #available(iOS 11.0, *) {
            cr = smallBottomView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: tabBarHeight)
        } else {
            cr = smallBottomView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: tabBarHeight)
        }
        
        cr.priority = .defaultHigh
        cr.isActive = true
        
        smallBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        smallBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupTabBar() {
        customTabBar.delegate = self
        self.view.addSubview(customTabBar)
        
        customTabBar.bottomAnchor.constraint(equalTo: smallBottomView.topAnchor, constant: 0).isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: horizontleSpacing).isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        
        self.view.bringSubviewToFront(customTabBar)
        self.view.bringSubviewToFront(smallBottomView)
        
        customTabBar.tintColor = tintColor
    }
}
// MARK: - Extensions
extension CustomTabBarController: CardTabBarDelegate {
    func cardTabBar(_ sender: CustomTabBar, didSelectItemAt index: Int) {
        self.selectedIndex = index
    }
}

extension CustomTabBar {
    // 그라데이션 효과 적용
    func setGradient(color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = bounds
        gradient.cornerRadius = 35
        layer.addSublayer(gradient)
    }
    
    // Blur Effect 적용
    func setBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.layer.cornerRadius = 35
        blurEffectView.clipsToBounds = true
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
    }
}
