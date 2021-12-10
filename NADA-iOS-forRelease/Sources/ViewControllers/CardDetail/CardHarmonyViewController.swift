//
//  CardHarmonyViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/10.
//

import UIKit

class CardHarmonyViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var dimmedBackView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var harmonyImageView: UIImageView!
    @IBOutlet weak var harmonyPercentLabel: UILabel!
    @IBOutlet weak var harmonyDescriptionLabel: UILabel!
    
    @IBAction func touchDismissButton(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
            self.popUpView.isHidden = true
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    var percentageColor: UIColor?
    
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
