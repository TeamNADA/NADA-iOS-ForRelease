//
//  CardView.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/28.
//

import UIKit

class CardView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    
    @IBOutlet weak var instagramIDLabel: UILabel!
    @IBOutlet weak var lineURLLabel: UILabel!
    
    @IBOutlet weak var instagramIcon: UIImageView!
    @IBOutlet weak var urlIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib(nib: Const.Xib.cardView) else {
            return
        }
        view.frame = bounds
        view.layer.cornerRadius = 15
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
