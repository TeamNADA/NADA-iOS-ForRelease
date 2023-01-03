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
    // FIXME: - 명함생성뷰에서 날짜를 넘길때 에러.(0.0.0 이 아닌 0월 0일로 반영)
    private var selectedBirth = String()
    
    @frozen
    private enum Column: Int, CaseIterable {
        case month = 0
        case day = 1
    }
    
    // MARK: - Components
    
    private let birthPicker: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "btnMainDone"), for: .normal)
        button.addTarget(SelectBirthBottomSheetViewController.self, action: #selector(dismissToCardCreationViewController), for: .touchUpInside)
        
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
        
        selectedBirth = monthList[0] + " " + dayList[0]
        
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
        return Column.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let row = Column(rawValue: component) else { return 0 }
        
        switch row {
        case .month:
            return monthList.count
        case .day:
            return dayList.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()

        label.textAlignment = .center

        guard let colum = Column(rawValue: component) else { return label }
        
        switch colum {
        case .month:
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: monthList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])

            } else {
                label.attributedText = NSAttributedString(string: monthList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        case .day:
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
        
        guard let colum = Column(rawValue: component) else { return }
        
        switch colum {
        case .month:
            month = monthList[row]
        case .day:
            day = dayList[row]
        }
        
        month = month.isEmpty ? monthList[0] : month
        day = day.isEmpty ? dayList[0] : day
        selectedBirth = month + " " + day
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerViewRowHeight
    }
}
