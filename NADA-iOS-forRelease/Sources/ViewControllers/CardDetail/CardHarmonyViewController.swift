//
//  CardHarmonyViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/10.
//

import UIKit

class CardHarmonyViewController: UIViewController {

    @IBOutlet weak var harmonyImageView: UIImageView!
    @IBOutlet weak var harmonyPercentLabel: UILabel!
    @IBOutlet weak var harmonyDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

}

extension CardHarmonyViewController {
    private func setUI() {
        harmonyImageView.image = UIImage(named: "icnHarmonyRed")
        harmonyPercentLabel.text = "10%"
        
        harmonyDescriptionLabel.text = "좀 더 친해지길 바라..😅"
    }
}
