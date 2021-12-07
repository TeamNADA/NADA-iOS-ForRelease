//
//  CardDetailViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/07.
//

import UIKit

class CardDetailViewController: UIViewController {
    
    // MARK: - Properties
    // 네비게이션 바
    @IBAction func touchBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func touchOptionButton(_ sender: Any) {
        
    }
    
    @IBOutlet weak var optionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
