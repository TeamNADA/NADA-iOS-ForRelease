//
//  MoreViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import UIKit

class MoreViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var firstItems = ["개인정보 처리방침", "서비스 이용약관", "Team NADA", "오픈소스 라이브러리"]
    var secondItems = ["로그아웃", "정보 초기화", "회원탈퇴"]
    
    @IBOutlet weak var moreListTableView: UITableView!
//    @IBOutlet weak var darkModeHeaderView: UIView!
//    @IBOutlet weak var modeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        moreListTableView.register(MoreListTableViewCell.nib(), forCellReuseIdentifier: "MoreListTableViewCell")
        
        moreListTableView.delegate = self
        moreListTableView.dataSource = self
        // moreListTableView.tableHeaderView = darkModeHeaderView
        
        // TODO: - 다크 모드 대응용 서버 코드
        // modeSwitch.isOn = defaults.bool(forKey: "darkModeState")
    
//        if let window = UIApplication.shared.windows.first {
//            if #available(iOS 13.0, *) {
//                window.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
//                defaults.set(modeSwitch.isOn, forKey: "darkModeState")
//            } else {
//                window.overrideUserInterfaceStyle = .light
//            }
//        }
    }
    
//    @IBAction func darkModeChangeSwitch(_ sender: UISwitch) {
//        // TODO: - 다크 모드 대응용 서버 코드
//        if let window = UIApplication.shared.windows.first {
//            if #available(iOS 13.0, *) {
//                window.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
//                defaults.set(modeSwitch.isOn, forKey: "darkModeState")
//            } else {
//                window.overrideUserInterfaceStyle = .light
//            }
//        }
//    }
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
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.moreListTableViewCell, for: indexPath) as? MoreListTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            serviceCell.titleLabel.text = firstItems[indexPath.row]
            if indexPath.row == firstItems.count - 1 {
                serviceCell.separatorView.isHidden = true
            }
        } else if indexPath.section == 1 {
            serviceCell.titleLabel.text = secondItems[indexPath.row]
        }
        
        return serviceCell
    }
}
