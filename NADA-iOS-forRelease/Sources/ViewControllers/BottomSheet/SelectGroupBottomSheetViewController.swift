//
//  SelectGroupBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/28.
//

import UIKit

class SelectGroupBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties
    var groupList = ["미분류", "SOPT", "동아리", "인하대학교"]
    var selectedGroup = ""
    enum Status {
        case detail
        case add
    }
    
    var status: Status = .add
    
    private let groupPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.autoresizingMask = .flexibleWidth
        
        return pickerView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "btnMainDone"), for: .normal)
        button.addTarget(self, action: #selector(presentCardInfoViewController), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(groupPicker)
        view.addSubview(doneButton)
        selectedGroup = groupList[0]
        groupPicker.delegate = self
        groupPicker.dataSource = self
        setupLayout()
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        groupPicker.selectedRow(inComponent: 0)
        groupPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -20),
            groupPicker.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            groupPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            groupPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: groupPicker.bottomAnchor, constant: 0),
            doneButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc func presentCardInfoViewController() {
        switch status {
        case .detail:
            // TODO: 그룹 변경 서버통신
            hideBottomSheetAndGoBack()
        case .add:
            print(selectedGroup)
            
            guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.cardDetail, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardDetailViewController) as? CardDetailViewController else { return }
            nextVC.status = .add
            hideBottomSheetAndPresentVC(nextViewController: nextVC)
        }
    }

}

extension SelectGroupBottomSheetViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupList.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textAlignment = .center
        
        if pickerView.selectedRow(inComponent: component) == row {
            label.attributedText = NSAttributedString(string: groupList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])
        } else {
            label.attributedText = NSAttributedString(string: groupList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGroup = groupList[row]
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
}
