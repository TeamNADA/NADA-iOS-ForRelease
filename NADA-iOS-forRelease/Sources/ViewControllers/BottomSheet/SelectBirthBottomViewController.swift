//
//  SelectBirthBottomViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/30.
//

import UIKit

class SelectBirthBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties
    
    private let monthList: [String] = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    private let dayList: [String] = ["1일", "2일", "3일", "4일", "5일", "6일", "7일", "8일", "9일", "10일", "11일", "12일", "13일", "14일", "15일", "16일", "17일", "18일", "19일", "20일", "21일", "22일", "23일", "24일", "25일", "26일", "27일", "28일", "29일", "30일", "31일"]
    private let pickerViewRowHeight: CGFloat = 44.0
    private var month = String()
    private var day = String()
    private var selectedBirth = String()
    
    // MARK: - Components
    
    private let monthPicker: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    private let dayPicker: UIPickerView = {
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
        view.addSubview(monthPicker)
        view.addSubview(dayPicker)
        view.addSubview(doneButton)
        
        selectedBirth = setBirth(month: monthList[0], day: dayList[0])
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        dayPicker.delegate = self
        dayPicker.dataSource = self
        
        setupLayout()
    }
    
    private func setupLayout() {
        monthPicker.selectedRow(inComponent: 0)
        monthPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -20),
            monthPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            monthPicker.widthAnchor.constraint(equalToConstant: (view.frame.width - 32) / 2)
        ])
        
        dayPicker.selectedRow(inComponent: 0)
        dayPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -20),
            dayPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dayPicker.widthAnchor.constraint(equalToConstant: (view.frame.width - 32) / 2)
        ])
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: monthPicker.bottomAnchor, constant: 0),
            doneButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setBirth(month: String, day: String) -> String {
        var birth: String = ""
        
        if month.count == 2 {
            birth.append("0\(month)")
        } else {
            birth.append(month)
        }
        
        birth.append(" ")
        
        if day.count == 2 {
            birth.append("0\(day)")
        } else {
            birth.append(day)
        }
        
        return birth
    }
    
    // MARK: - @objc Methods
    
    @objc func dismissToCardCreationViewController() {
        NotificationCenter.default.post(name: .completeFrontCardBirth, object: selectedBirth)
        hideBottomSheetAndGoBack()
    }
}

extension SelectBirthBottomSheetViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPicker {
            return monthList.count
        } else {
            return dayList.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let backgroundView = pickerView.subviews[1]
        backgroundView.cornerRadius = 23
        backgroundView.frame = CGRect(x: backgroundView.frame.minX, y: backgroundView.frame.minY, width: backgroundView.frame.width, height: 44)
        
        let label = (view as? UILabel) ?? UILabel()

        label.textAlignment = .center
        
        if pickerView == monthPicker {
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: monthList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])
                
            } else {
                label.attributedText = NSAttributedString(string: monthList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        } else {
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
        
        if pickerView == monthPicker {
            month = monthList[row]
        } else {
            day = dayList[row]
        }
        
        month = month.isEmpty ? monthList[0] : month
        day = day.isEmpty ? dayList[0] : day
        selectedBirth = setBirth(month: month, day: day)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerViewRowHeight
    }
}
