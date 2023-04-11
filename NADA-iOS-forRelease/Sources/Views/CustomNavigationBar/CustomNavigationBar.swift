//
//  CustomNavigationBar.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/28.
//

import SnapKit
import Then
import UIKit

/*
 
 공통으로 사용할 수 있도록 만들어둔 네비게이션 바 입니다.
 
 1) CustomNavigationBar에는 공통으로 필요한 요소들을 구현해둔 상태에요.
 2) 해당 ViewController로 가서 CustomNavigationBar를 상속받은 UIView 생성 (ex: navigationBar)
 3) navigationBar.leftButtonAction = { 왼쪽버튼을 누르면 해야할 것 } 을 추가해요.
 4) navigationBar.rightButtonAction = { 오른쪽버튼을 누르면 해야할 것 } 을 추가해요.
 5) func setUI(_ title: String?, leftImage: UIImage?, rightImage: UIImage?) 함수를 이용하여 왼쪽/오른쪽 아이템과 타이틀을 바꿔주세요.
 
 */

class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    
    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.textColor = .primary
        $0.font = .title02
        $0.sizeToFit()
    }
    private lazy var leftButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchLeftButton(_:)), for: .touchUpInside)
    }
    private lazy var rightButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchRightButton(_:)), for: .touchUpInside)
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI & Layout
    
    func setUI(_ title: String?, leftImage: UIImage?, rightImage: UIImage?) {
        titleLabel.text = title
        leftButton.setImage(leftImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.setImage(rightImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func setLayout() {
        addSubviews([leftButton, titleLabel, rightButton])
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
            make.height.width.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(25)
            make.height.width.equalTo(24)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchLeftButton(_ sender: UIButton) {
        leftButtonAction?()
    }
    
    @objc func touchRightButton(_ sender: UIButton) {
        rightButtonAction?()
    }
}
