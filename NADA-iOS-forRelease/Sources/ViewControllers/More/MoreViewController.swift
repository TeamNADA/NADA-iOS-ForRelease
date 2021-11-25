//
//  MoreViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import UIKit

class MoreViewController: UIViewController {
    
    var firstItems = ["다크 모드"]
    var secondItems = ["개인정보 처리방침", "서비스 이용약관", "Team NADA", "오픈소스 라이브러리"]
    var thirdItems = ["로그아웃", "정보 초기화", "회원탈퇴"]
    
    @IBOutlet weak var moreListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreListTableView.register(MoreListTableViewCell.nib(), forCellReuseIdentifier: "MoreListTableViewCell")
        
        moreListTableView.delegate = self
        moreListTableView.dataSource = self
    }
}

// MARK: - TableView Delegate
extension MoreViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

// MARK: - TableView DataSource
extension MoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstItems.count
        } else if section == 1 {
            return secondItems.count
        } else if section == 2 {
            return thirdItems.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.moreListTableViewCell, for: indexPath) as? MoreListTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            serviceCell.titleLabel.text = firstItems[indexPath.row]
        } else if indexPath.section == 1 {
            serviceCell.titleLabel.text = secondItems[indexPath.row]
            serviceCell.modeSwitch.isHidden = true
        } else if indexPath.section == 2 {
            serviceCell.titleLabel.text = thirdItems[indexPath.row]
            serviceCell.modeSwitch.isHidden = true
        }
        
        return serviceCell
    }
}
