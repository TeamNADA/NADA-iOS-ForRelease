//
//  CommonBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import UIKit

/**
 공통으로 사용할 수 있도록 만들어둔 바텀 시트입니다.
 
 1) CommonBottomSheetViewController에는 공통으로 필요한 요소들만 구현해둔 상태
 2) CommonBottomSheetViewController를 상속받은 뷰컨 생성 (예시: InheritanceViewController)
 3) InheritanceViewController에 텍스트 필드, 피커 뷰, 버튼 등 각 화면에 맞는 추가 기능 구현
 4) .setHeight 메서드 파라미터로 높이값을 조정 (default값은 475)
 5) .setTitle 메서드 파라미터로 가장 상단 타이틀 라벨에 들어갈 내용 입력 (String)
 6) present 방식으로 화면에 표출 (주의!! 이때 present animated는 false로 둬야 지연없이 바텀시트가 올라옵니다 ^_^)
*/

class CommonBottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    // 바텀 시트 높이
    var bottomHeight: CGFloat = 475
    
    // bottomSheet가 view의 상단에서 떨어진 거리
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    private var hideAnimationDuration: Float = 0.2
    
    // 기존 화면을 흐려지게 만들기 위한 뷰
    let dimmedBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .bottomDimmedBackground
        return view
    }()
    
    // 바텀 시트 뷰
    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        
        view.layer.cornerRadius = 27
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    // 자연스러운 애니메이션을 위한..커버..
    let bottomSheetCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        
        view.layer.cornerRadius = 27
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    // dismiss Indicator View UI 구성 부분
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .textBox
        view.layer.cornerRadius = 3
        
        return view
    }()
    
    // 바텀 시트 메인 라벨
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .title01
        label.textColor = .primary
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        view.addSubview(dismissIndicatorView)
        view.addSubview(titleLabel)
        view.addSubview(bottomSheetCoverView)
        
        dimmedBackView.alpha = 0.0
        setupLayout()
    }
    
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        // 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        dimmedBackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedBackView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint
        ])
        
        bottomSheetCoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSheetCoverView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            bottomSheetCoverView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            bottomSheetCoverView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            bottomSheetCoverView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])
        
        dismissIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 102),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 7),
            dismissIndicatorView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 12),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dismissIndicatorView.bottomAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
    }
    
    // 바텀 시트 표출 애니메이션
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.dimmedBackView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.bottomSheetCoverView.isHidden = true
        })
    }
    
    // 바텀 시트 사라지는 속도 조절
    func setHideAnimationDuration(_ duration: Float) {
        self.hideAnimationDuration = duration
    }
    
    // 바텀 시트 사라지는 애니메이션
    func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: TimeInterval(hideAnimationDuration), delay: 0, options: .curveEaseOut, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
            self.bottomSheetCoverView.isHidden = false
        }, completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    // 바텀 시트 사라지고 바로 다시 다음 바텀 시트 올라오는 애니메이션
    func hideBottomSheetAndPresent(nextBottomSheet: CommonBottomSheetViewController, title: String, height: CGFloat) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: TimeInterval(hideAnimationDuration), delay: 0, options: .curveEaseOut, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
            self.bottomSheetCoverView.isHidden = false
        }, completion: { _ in
            if self.presentingViewController != nil {
                guard let presentingVC = self.presentingViewController else { return }
                self.dismiss(animated: false) {
                    let nextVC = nextBottomSheet.setTitle(title).setHeight(height)
                    nextVC.modalPresentationStyle = .overFullScreen
                    presentingVC.present(nextVC, animated: false, completion: nil)
                }
            }
        })
    }
    
    func hideBottomSheetAndPresentVC(nextViewController: UIViewController) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: TimeInterval(hideAnimationDuration), delay: 0, options: .curveEaseOut, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
            self.bottomSheetCoverView.isHidden = false
        }, completion: { _ in
            if self.presentingViewController != nil {
                guard let presentingVC = self.presentingViewController else { return }
                self.dismiss(animated: false) {
                    let nextVC = nextViewController
                    nextVC.modalPresentationStyle = .overFullScreen
                    presentingVC.present(nextVC, animated: true, completion: nil)
                }
            }
        })
    }
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // UISwipeGestureRecognizer 연결 함수 부분
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
        }
    }
}

// MARK: - Extensions
// 재사용을 위한 함수는 extension에 구현
extension CommonBottomSheetViewController {
    // 바텀 시트 높이 설정
    func setHeight(_ height: CGFloat) -> Self {
        bottomHeight = height
        return self
    }
    
    // 타이틀 라벨 내용 추가
    func setTitle(_ text: String) -> Self {
        titleLabel.text = text
        return self
    }
}
