//
//  CustomTabBar.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/09.
//

import Foundation
import UIKit

protocol CardTabBarDelegate: AnyObject {
    func cardTabBar(_ sender: CustomTabBar, didSelectItemAt index: Int)
}

open class CustomTabBar: UIView {
    
    weak var delegate: CardTabBarDelegate?
    
    var items: [UITabBarItem] = [] {
        didSet {
            reloadViews()
        }
    }
    
    override open func tintColorDidChange() {
        super.tintColorDidChange()
        reloadApperance()
    }
    
    func reloadApperance() {
        
        buttons().forEach { button in
            button.selectedColor = tintColor
        }
        
        indicatorView.tintColor = tintColor
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    lazy var indicatorView: CustomTabIndicatorView = {
        let view = CustomTabIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // view.constraint(width: 5)
        // view.backgroundColor = tintColor
        // view.makeWidthEqualHeight()
        
        return view
    }()
    
    private var indicatorViewYConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        stackView.arrangedSubviews.forEach {
            if let button = $0 as? UIControl {
                button.removeTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            }
        }
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(indicatorView)
        
        // self.backgroundColor = .black1
        self.setGradient(color1: UIColor(red: 1, green: 1, blue: 1, alpha: 0.35),
                         color2: UIColor(red: 1, green: 1, blue: 1, alpha: 0.15))
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.15
        
        indicatorViewYConstraint?.isActive = false
        indicatorViewYConstraint = indicatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10.5)
        indicatorViewYConstraint.isActive = true
        
        tintColorDidChange()
    }
    
    func add(item: UITabBarItem) {
        self.items.append(item)
        self.addButton(with: item.image!)
    }
    
    func remove(item: UITabBarItem) {
        if let index = self.items.firstIndex(of: item) {
            self.items.remove(at: index)
            let view = self.stackView.arrangedSubviews[index]
            self.stackView.removeArrangedSubview(view)
        }
    }
    
    private func addButton(with image: UIImage) {
        let button = CustomTabBarButton(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.selectedColor = tintColor
        
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        self.stackView.addArrangedSubview(button)
    }
    
    func select(at index: Int, notifyDelegate: Bool = true) {
        for (bIndex, view) in stackView.arrangedSubviews.enumerated() {
            if let button = view as? UIButton {
                button.tintColor =  bIndex == index ? tintColor : .hintGray1
            }
        }
        
        if notifyDelegate {
            self.delegate?.cardTabBar(self, didSelectItemAt: index)
        }
    }
    
    func reloadViews() {
        indicatorViewYConstraint?.isActive = false
        indicatorViewYConstraint = indicatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10.5)
        indicatorViewYConstraint.isActive = true
        
        for button in (stackView.arrangedSubviews.compactMap { $0 as? CustomTabBarButton }) {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
            button.removeTarget(self, action: nil, for: .touchUpInside)
        }
        
        for item in items {
            if let image = item.image {
                addButton(with: image)
            } else {
                addButton(with: UIImage())
            }
        }
        
        select(at: 0)
    }
    
    private func buttons() -> [CustomTabBarButton] {
        return stackView.arrangedSubviews.compactMap { $0 as? CustomTabBarButton }
    }
    
    func select(at index: Int) {
        /* move the indicator view */
        //        if indicatorViewXConstraint != nil {
        //            indicatorViewXConstraint.isActive = false
        //            indicatorViewXConstraint = nil
        //        }
        
        for (bIndex, button) in buttons().enumerated() {
            button.selectedColor = tintColor
            button.isSelected = bIndex == index
            
            //            if bIndex == index {
            //                indicatorViewXConstraint = indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
            //                indicatorViewXConstraint.isActive = true
            //            }
        }
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        
        self.delegate?.cardTabBar(self, didSelectItemAt: index)
    }
    
    @objc func buttonTapped(sender: CustomTabBarButton) {
        if let index = stackView.arrangedSubviews.firstIndex(of: sender) {
            select(at: index)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        let buttons = self.stackView.arrangedSubviews.compactMap { $0 as? CustomTabBarButton }.filter { !$0.isHidden }
        let distances = buttons.map { $0.center.distance(to: position) }
        
        let buttonsDistances = zip(buttons, distances)
        
        if let closestButton = buttonsDistances.min(by: { $0.1 < $1.1 }) {
            buttonTapped(sender: closestButton.0)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        layer.cornerRadius = bounds.height / 2
    }
}

// 그라데이션 배경 추가
extension CustomTabBar {
    func setGradient(color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
