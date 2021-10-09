//
//  RootStackTabViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import UIKit

class RootStackTabViewController: UIViewController {

    @IBOutlet weak var bottomStack: UIStackView!
    
    var currentIndex = 0
    
    lazy var tabs: [StackItemView] = {
        var items = [StackItemView]()
        for _ in 0..<2 {
            items.append(StackItemView.newInstance)
        }
        return items
    }()
    
    lazy var tabModels: [BottomStackItem] = {
        return [
            BottomStackItem(tabImage: "homeBtnOnClick"),
            BottomStackItem(tabImage: "myCardBtn")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
    }
    
    // MARK: - Functions
    func setupTabs() {
        for (index, model) in self.tabModels.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            self.bottomStack.addArrangedSubview(tabView)
        }
    }

}

extension RootStackTabViewController: StackItemViewDelegate {
    func handleTap(_ view: StackItemView) {
        self.tabs[self.currentIndex].isSelected = false
        view.isSelected = true
        self.currentIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
    }
}
