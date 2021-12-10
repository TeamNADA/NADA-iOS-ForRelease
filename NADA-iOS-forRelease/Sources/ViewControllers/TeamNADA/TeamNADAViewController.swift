//
//  TeamNADAViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/11.
//

import UIKit

class TeamNADAViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBackSwipeMotion()
        setUI()
    }
    
    @IBAction func dismissToPreviousView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TeamNADAViewController {
    
    private func setUI() {
        
    }
    
    func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
