//
//  CardCreationCategoryViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/02/20.
//

import SnapKit
import RxSwift
import RxCocoa

import UIKit

class CardCreationCategoryViewController: UIViewController {
    
    // MARK: - Components
    
    private let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconArrow"), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "명함 만들기"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let basicBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardCreationUnclicked
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let basicTextlabel: UILabel = {
        let label = UILabel()
        label.text = "기본"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let basicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnBasic")
        
        return imageView
    }()
    
    private let jobBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardCreationUnclicked
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let jobTextlabel: UILabel = {
        let label = UILabel()
        label.text = "직장"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let jobImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnOffice")
        
        return imageView
    }()
    
    private let diggingBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardCreationUnclicked
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let diggingTextlabel: UILabel = {
        let label = UILabel()
        label.text = "덕질"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let diggingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnFan")
        
        return imageView
    }()
    
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconDone")
        
        return imageView
    }()
    
    private let contentTextlabel: UILabel = {
        let label = UILabel()
        label.text = """
                    다크모드를 켜고 아이콘의 재미있는 포인트를 찾아보세요👀
                    (더보기 > 다크모드 스위치 활성화)
                    """
        label.numberOfLines = 2
        label.textColor = .mainColorButtonText
        label.font = .textRegular05
        
        return label
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
}

// MARK: - Extension

extension CardCreationCategoryViewController {
    private func setUI() {
        view.backgroundColor = .white
    }
}

// MARK: - Layout

extension CardCreationCategoryViewController {
    private func setLayout() {
        view.addSubviews([navigationBarView, basicBackgroundView, jobBackgroundView, diggingBackgroundView, checkMarkImageView, contentTextlabel])
        navigationBarView.addSubviews([backButton, titleLabel])
        basicBackgroundView.addSubviews([basicTextlabel, basicImageView])
        jobBackgroundView.addSubviews([jobTextlabel, jobImageView])
        diggingBackgroundView.addSubviews([diggingTextlabel, diggingImageView])
        
        navigationBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.height.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        basicBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.centerY).offset(-63)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(basicBackgroundView.snp.width).multipliedBy(117.0 / 327.0)
        }
        
        basicTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(14)
        }
        
        basicImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(9)
        }
        
        jobBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(basicBackgroundView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(basicBackgroundView.snp.width).multipliedBy(117.0 / 327.0)
        }
        
        jobTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(14)
        }
        
        jobImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(9)
        }
        
        diggingBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(jobBackgroundView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(basicBackgroundView.snp.width).multipliedBy(117.0 / 327.0)
        }
        
        diggingTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(14)
        }
        
        diggingImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(9)
        }
        
        checkMarkImageView.snp.makeConstraints { make in
            make.top.equalTo(diggingBackgroundView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(24)
        }
        
        contentTextlabel.snp.makeConstraints { make in
            make.leading.equalTo(checkMarkImageView.snp.trailing).offset(5)
            make.top.equalTo(checkMarkImageView).offset(3)
        }
    }
}
