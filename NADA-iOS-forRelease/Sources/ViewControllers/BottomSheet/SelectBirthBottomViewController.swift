//
//  SelectBirthBottomViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/30.
//

import UIKit

class SelectBirthBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties
    
    private let yearList: [String] = [Int](1950...2021).map { String($0) }.reversed()
    private let monthList: [String] = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    private let dayList: [String] = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    private var year = String()
    private var month = String()
    private var day = String()
    private var selectedBirth = String()
    
    // MARK: - Components
    
    private let birthPicker: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "btnMainDone"), for: .normal)
        button.addTarget(self, action: #selector(dismissToCardCreationViewController), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - override Methods
    
    override func hideBottomSheetAndGoBack() {
        super.hideBottomSheetAndGoBack()
        
        NotificationCenter.default.post(name: .dismissRequiredBottomSheet, object: nil)
    }
}
    
// MARK: - Extensions

extension SelectBirthBottomSheetViewController {
    private func setupUI() {
        view.addSubview(birthPicker)
        view.addSubview(doneButton)
        
        selectedBirth = yearList[0] + "." + monthList[0] + "." + dayList[0]
        
        birthPicker.delegate = self
        birthPicker.dataSource = self
        
        setupLayout()
    }
    private func setupLayout() {
        birthPicker.selectedRow(inComponent: 0)
        birthPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            birthPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -20),
            birthPicker.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            birthPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            birthPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: birthPicker.bottomAnchor, constant: 0),
            doneButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - @objc Methods
    
    @objc func dismissToCardCreationViewController() {
        NotificationCenter.default.post(name: .completeFrontCardBirth, object: selectedBirth)
        hideBottomSheetAndGoBack()
    }

}

extension SelectBirthBottomSheetViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return yearList.count
        } else if component == 1 {
            return monthList.count
        } else {
            return dayList.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()

        label.textAlignment = .center

        if component == 0 {
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: yearList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])

            } else {
                label.attributedText = NSAttributedString(string: yearList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        } else if component == 1 {
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: monthList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])

            } else {
                label.attributedText = NSAttributedString(string: monthList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        } else if component == 2 {
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: dayList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])

            } else {
                label.attributedText = NSAttributedString(string: dayList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        }
        
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        
        if component == 0 {
            year = yearList[row]
        } else if component == 1 {
            month = monthList[row]
        } else if component == 2 {
            day = dayList[row]
        }
        year = year.isEmpty ? yearList[0] : year
        month = month.isEmpty ? monthList[0] : month
        day = day.isEmpty ? dayList[0] : day
        selectedBirth = year + "." + month + "." + day
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
