//
//  GroupEditTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/21.
//

import UIKit

class GroupEditTableViewCell: UITableViewCell {

    // MARK: - @IBOutlet Properties
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // MARK: - Functions
    static func nib() -> UINib {
        return UINib(nibName: "GroupEditTableViewCell", bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initData(title: String) {
        titleLabel.text = title
    }
}
