//
//  SelectMBTIBottomViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/01.
//

import UIKit

class SelectMBTIBottmViewController: CommonBottomSheetViewController {
    
    // MARK: - Properties
    
    private let firstList: [String] = ["E", "I"]
    private let secondList: [String] = ["N", "S"]
    private let thirdList: [String] = ["T", "F"]
    private let fourthList: [String] = ["J", "P"]
    private var first = String()
    private var second = String()
    private var third = String()
    private var fourth = String()
    private var selectedMBTI = String()
    
    // MARK: - Components
    
    private let mbtiPicker: UIPickerView = {
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
    
    // MARK: - Methods
    
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(mbtiPicker)
        view.addSubview(doneButton)
        
        selectedMBTI = firstList[0] + secondList[0] + thirdList[0] + fourthList[0]
        
        mbtiPicker.delegate = self
        mbtiPicker.dataSource = self
        
        setupLayout()
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        mbtiPicker.selectedRow(inComponent: 0)
        mbtiPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mbtiPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -20),
            mbtiPicker.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: mbtiPicker.bottomAnchor, constant: 0),
            doneButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
    }
    
    @objc func dismissToCardCreationViewController() {
        NotificationCenter.default.post(name: .frontCardMBTI, object: selectedMBTI)
        hideBottomSheetAndGoBack()
    }

}

extension SelectMBTIBottmViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return firstList.count
        } else if component == 1 {
            return secondList.count
        } else if component == 2 {
            return thirdList.count
        } else {
            return fourthList.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()

        label.textAlignment = .center
        
        if component == 0 {
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: firstList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])

            } else {
                label.attributedText = NSAttributedString(string: firstList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        } else if component == 1 {
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: secondList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])

            } else {
                label.attributedText = NSAttributedString(string: secondList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        } else if component == 2 {
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: thirdList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])

            } else {
                label.attributedText = NSAttributedString(string: thirdList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        } else {
            if pickerView.selectedRow(inComponent: component) == row {
                label.attributedText = NSAttributedString(string: fourthList[row], attributes: [NSAttributedString.Key.font: UIFont.textBold01, NSAttributedString.Key.foregroundColor: UIColor.mainColorNadaMain])

            } else {
                label.attributedText = NSAttributedString(string: fourthList[row], attributes: [NSAttributedString.Key.font: UIFont.textRegular03, NSAttributedString.Key.foregroundColor: UIColor.quaternary])
            }
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            first = firstList[row]
        } else if component == 1 {
            second = secondList[row]
        } else if component == 2 {
            third = thirdList[row]
        } else if component == 3 {
            fourth = fourthList[row]
        }

        first = first.isEmpty ? firstList[0] : first
        second = second.isEmpty ? secondList[0] : second
        third = third.isEmpty ? thirdList[0] : third
        fourth = fourth.isEmpty ? fourthList[0] : fourth
        
        selectedMBTI = first + second + third + fourth
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
//
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return  CGFloat(pickerView.frame.size.width / 4)
    }
}
