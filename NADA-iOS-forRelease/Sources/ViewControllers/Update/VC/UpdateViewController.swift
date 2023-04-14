//
//  UpdateViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/03/21.
//

import UIKit

import FlexLayout
import PinLayout

class UpdateViewController: UIViewController {

    // MARK: - Components
    
    private let rootFlexContainer = UIView()
    private let updateCardImageView = UIImageView()
    private let cancelButton = UIButton()
    private let updateContentLabel = UILabel()
    private let checkBoxButton = UIButton()
    private let checkLabel = UILabel()
    private let updateButton = UIButton()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        addTargets()
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.vCenter().hCenter().height(487).width(327)
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Extension

extension UpdateViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
        
        rootFlexContainer.backgroundColor = .background
        rootFlexContainer.layer.cornerRadius = 20
        
        updateCardImageView.image = UIImage(named: "imgUpdate")
        
        cancelButton.setImage(UIImage(named: "iconClear"), for: .normal)
        
        updateContentLabel.numberOfLines = 10
        updateContentLabel.font = .textRegular04
        updateContentLabel.textColor = .secondary
        updateContentLabel.lineBreakMode = .byCharWrapping
        updateContentLabel.text = """
                                안녕하세요, 나다입니다.
                                이번 업데이트에서는 아래와 같은 내용이 개선되었습니다.
                                안녕하세융
                                나다에요
                                -명함을 위젯으로 추가할 수 있어요
                                -내 주변의 명함을 검색할 수 있어요
                                ㅇㅇㅇ
                                앱스토어에서 최신 버전을 확인해 보세요!
                                이정도면 10줄!
                                """
        
        checkBoxButton.setImage(UIImage(named: "icnCheckboxUnfilled"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "icnCheckboxFilled"), for: .selected)
        
        checkLabel.font = .textRegular05
        checkLabel.textColor = .tertiary
        checkLabel.text = "확인했어요!"
        
        updateButton.setImage(UIImage(named: "btnMainGoUpdate"), for: .normal)
    }
    
    private func addTargets() {
        cancelButton.addTarget(self, action: #selector(touchCancelButton), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(touchUpdateButton), for: .touchUpInside)
        checkBoxButton.addTarget(self, action: #selector(touchCheckBox), for: .touchUpInside)
    }
    
    // MARK: - Objc Methods
    
    @objc
    private func touchCancelButton() {
        guard let updateNote else { return }
        if updateNote.isForce {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                exit(0)
            }
        } else {
            // TODO: - 확인했어요 API 통신
            self.dismiss(animated: true)
        }
    }
    
    @objc
    private func touchUpdateButton() {
        let appID = "1600711887"
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/\(appID)") else { return }
        guard let updateNote else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
        if !updateNote.isForce {
            // TODO: - 확인했어요 API 통신
        }
    }
    
    @objc
    private func touchCheckBox(_ sender: UIButton) {
        // TODO: - 체크하게 되면 다시 띄어주지 않음
        checkBoxButton.isSelected.toggle()
    }
}

// MARK: - Layout

extension UpdateViewController {
    private func setLayout() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).justifyContent(.spaceBetween).define { flex in
            flex.addItem().direction(.column).define { flex in
                flex.addItem().direction(.column).alignItems(.center).define { flex in
                        flex.addItem(updateCardImageView).marginTop(20)
                        flex.addItem(cancelButton).position(.absolute).top(20).right(20)
                    }
                flex.addItem(updateContentLabel).marginTop(16).marginBottom(18).marginHorizontal(16)
            }
            flex.addItem().direction(.column).define { flex in
                flex.addItem().direction(.row).alignItems(.center).marginBottom(20).define { flex in
                    flex.addItem(checkBoxButton).marginLeft(16).size(16)
                    flex.addItem(checkLabel).marginLeft(2)
                }
                flex.addItem(updateButton).marginBottom(16).marginHorizontal(17)
            }
        }
    }
}
