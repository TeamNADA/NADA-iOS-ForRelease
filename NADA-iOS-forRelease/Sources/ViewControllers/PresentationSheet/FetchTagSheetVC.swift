//
//  FetchTagSheetVC.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/13.
//

import UIKit

import SnapKit
import Then

class FetchTagSheetVC: UIViewController {

    // MARK: - Components
    
    private let grabber: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "iconBottomSheet")
    }
    private let titleLabel: UILabel = UILabel().then {
        $0.text = "받은 태그"
        $0.font = .title01
        $0.textColor = .primary
    }
    private let cancelButton: UIButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .button02
        $0.setTitleColor(.primary, for: .normal)
    }
    private let deleteButton: UIButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = .button02
        $0.setTitleColor(.quaternary, for: .normal)
    }
    private let tableView: UITableView = UITableView()
    
    // MARK: - Properties
    
    private var cardUUID: String?
//    private var tagList:
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        fetchTagListWithAPI()
    }
}

// MARK: - extension

extension FetchTagSheetVC {
    private func setUI() {
        view.backgroundColor = .background
        cancelButton.isHidden = true
    }
    private func setAddTargets() {
        cancelButton.addTarget(self, action: #selector(touchCancelButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(touchDeleteButton), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc
    private func touchCancelButton() {
        
    }
    @objc
    private func touchDeleteButton() {
        
    }
    
    public func setCardUUID(_ cardUUID: String) {
        self.cardUUID = cardUUID
    }
}

// MARK: - Layout

extension FetchTagSheetVC {
    private func setLayout() {
        view.addSubviews([grabber, titleLabel, cancelButton, deleteButton, tableView])
        
        grabber.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.centerX.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalTo(titleLabel)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalTo(titleLabel)
        }
    }
}

// MARK: - Network

extension FetchTagSheetVC {
    private func fetchTagListWithAPI() {
        
    }
}
