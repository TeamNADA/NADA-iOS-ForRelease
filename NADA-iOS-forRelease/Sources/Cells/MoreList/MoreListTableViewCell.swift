//
//  MoreListTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import UIKit

class MoreListTableViewCell: UITableViewCell {
    
    let myUserDefaults = UserDefaults.standard

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setModeBySwitch()
    }
    
    @IBAction func modeChangeButton(_ sender: Any) {
        myUserDefaults.set(modeSwitch.isOn, forKey: "switchState")
        
        if #available(iOS 13, *) {
            window!.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MoreListTableViewCell", bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setModeBySwitch() {
        modeSwitch.isOn = myUserDefaults.bool(forKey: "switchState")
    }
}
