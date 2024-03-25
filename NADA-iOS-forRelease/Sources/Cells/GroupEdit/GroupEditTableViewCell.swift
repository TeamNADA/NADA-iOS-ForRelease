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

    // MARK: - Functions
    static func nib() -> UINib {
        return UINib(nibName: "GroupEditTableViewCell", bundle: nil)
    }
    
    func initData(title: String) {
        titleLabel.text = title
    }
}
