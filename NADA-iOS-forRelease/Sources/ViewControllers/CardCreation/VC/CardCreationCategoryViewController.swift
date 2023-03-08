//
//  CardCreationCategoryViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/02/20.
//

import SnapKit

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
                    "다크모드를 켜고 아이콘의 재미있는 포인트를 찾아보세요👀
                    (더보기 > 다크모드 스위치 활성화)
                    """
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
        

    }
    
    private func setLayout() {
        
    }
}
