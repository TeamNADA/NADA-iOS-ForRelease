//
//  GroupEditTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/21.
//

import UIKit

class GroupEditTableViewCell: UITableViewCell {

    // MARK: - Properties
    weak var delegate: GroupEditViewDelegate?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupGestureRecognizer()
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

// MARK: - Extensions
extension GroupEditTableViewCell {
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        titleLabel.addGestureRecognizer(tapGestureRecognizer)
        titleLabel.isUserInteractionEnabled = true
    }
    
    @objc private func labelClicked(_ tapRecognizer: UITapGestureRecognizer) {
        delegate?.presentToGroupNameEdit()
    }
    
}

// MARK: - Protocol
protocol GroupEditViewDelegate: AnyObject {
    func presentToGroupNameEdit()
}
