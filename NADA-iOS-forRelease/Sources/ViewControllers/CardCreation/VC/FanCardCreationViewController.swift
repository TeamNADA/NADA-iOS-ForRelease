//
//  FanCardCreationViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/4/23.
//

import UIKit

import FirebaseAnalytics
import YPImagePicker

class FanCardCreationViewController: UIViewController {

    // MARK: - Properties
    
    enum ButtonState {
        case enable
        case disable
    }
    
    var completeButtonIsEnabled: ButtonState = .disable {
        didSet {
            if completeButtonIsEnabled == .disable {
                completeButton.isEnabled = false
                if #available(iOS 15.0, *) {
                    completeButton.setNeedsUpdateConfiguration()
                }
            } else {
                completeButton.isEnabled = true
                if #available(iOS 15.0, *) {
                    completeButton.setNeedsUpdateConfiguration()
                }
            }
        }
    }
    
    private var frontCardRequiredIsEmpty = true
    private var backCardRequiredIsEmpty = true
    private var isEditingMode = false
    private var currentIndex = 0
    private var frontCard: FrontCardDataModel?
    private var backCard: BackCardDataModel?
    private var mbtiText: String?
    private var birthText: String?
    private var backgroundImage: UIImage?
    private var tasteInfo: [TasteInfo]?
    
    private let cardType: CardType = .fan
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var creationTextLabel: UILabel!
    @IBOutlet weak var frontTextLabel: UILabel!
    @IBOutlet weak var backTextLabel: UILabel!

    @IBOutlet weak var statusMovedView: UIView!
    @IBOutlet weak var cardCreationCollectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        registerCell()
        setTextLabelGesture()
        setNotification()
        tasteFetchWithAPI(cardType: cardType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
    
    // MARK: - @IBAction Properties

    @IBAction func dismissToPreviousView(_ sender: Any) {
        if isEditingMode {
            makeOKCancelAlert(title: "입력 취소", message: "입력한 내용이 모두 삭제됩니다. 돌아가시겠습니까?", okAction: { _ in
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
        Analytics.logEvent(Tracking.Event.touchExitCreateFanCard, parameters: nil)
    }
    @IBAction func pushToCardCompletionView(_ sender: Any) {
        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.cardCreationPreview, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardCreationPreviewViewController) as? CardCreationPreviewViewController else { return }

        nextVC.frontCardDataModel = frontCard
        nextVC.backCardDataModel = backCard
        nextVC.cardBackgroundImage = backgroundImage
        nextVC.tasteInfo = tasteInfo
        nextVC.cardType = cardType
        navigationController?.pushViewController(nextVC, animated: true)
        
        Analytics.logEvent(Tracking.Event.touchFanCardPreview, parameters: nil)
    }
}

// MARK: - Extensions
extension FanCardCreationViewController {
    private func setUI() {
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .background
        statusMovedView.backgroundColor = .secondary
        cardCreationCollectionView.backgroundColor = .background
        cardCreationCollectionView.isPagingEnabled = true
        
        creationTextLabel.text = "명함 만들기"
        creationTextLabel.font = .title02
        creationTextLabel.textColor = .primary
        
        frontTextLabel.text = "앞면"
        frontTextLabel.font = .title01
        frontTextLabel.textColor = .primary
        
        backTextLabel.text = "뒷면"
        backTextLabel.font = .title01
        backTextLabel.textColor = .quaternary
        
        closeButton.setImage(UIImage(named: "iconClear"), for: .normal)
        closeButton.setTitle("", for: .normal)
        
        completeButton.titleLabel?.font = .button01
        completeButton.isEnabled = false
        
        // MARK: - #available(iOS 15.0, *)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.background.cornerRadius = 15
            completeButton.configuration = config

            let configHandler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .disabled:
                    button.configuration?.title = "완료"
                    button.configuration?.baseBackgroundColor = .textBox
                    button.configuration?.baseForegroundColor = .white
                default:
                    button.configuration?.title = "완료"
                    button.configuration?.baseBackgroundColor = .mainColorNadaMain
                    button.configuration?.baseForegroundColor = .white
                }
            }
            completeButton.configurationUpdateHandler = configHandler
        } else {
            completeButton.layer.cornerRadius = 15
            
            completeButton.setTitle("완료", for: .normal)
            completeButton.setTitleColor(.white, for: .normal)
            completeButton.setBackgroundImage(UIImage(named: "enableButtonBackground"), for: .normal)
            
            completeButton.setTitle("완료", for: .disabled)
            completeButton.setTitleColor(.white, for: .disabled)
            completeButton.setBackgroundImage(UIImage(named: "disableButtonBackground"), for: .disabled)
        }
        
        let cardCreationCollectionViewlayout = cardCreationCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        cardCreationCollectionViewlayout?.scrollDirection = .horizontal
        cardCreationCollectionViewlayout?.estimatedItemSize = .zero
        cardCreationCollectionView.showsHorizontalScrollIndicator = false
        cardCreationCollectionView.showsVerticalScrollIndicator = false
    }
    private func registerCell() {
        cardCreationCollectionView.delegate = self
        cardCreationCollectionView.dataSource = self

        cardCreationCollectionView.register(FanFrontCardCreationCollectionViewCell.nib(), forCellWithReuseIdentifier: FanFrontCardCreationCollectionViewCell.className)
        cardCreationCollectionView.register(BackCardCreationCollectionViewCell.nib(), forCellWithReuseIdentifier: BackCardCreationCollectionViewCell.className)
    }
    private func setTextLabelGesture() {
        let tapFrontTextLabelGesture = UITapGestureRecognizer(target: self, action: #selector(touchFront))
        frontTextLabel.addGestureRecognizer(tapFrontTextLabelGesture)
        frontTextLabel.isUserInteractionEnabled = true
        let tapBackTextLabelGesture = UITapGestureRecognizer(target: self, action: #selector(touchBack))
        backTextLabel.addGestureRecognizer(tapBackTextLabelGesture)
        backTextLabel.isUserInteractionEnabled = true
    }
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentToImagePicker), name: .presentingImagePicker, object: nil)
    }
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.createFanCard
                           ])
    }    
    
    // MARK: - @objc Methods
    
    @objc
    private func touchFront() {
        dragToFront()
        
        Analytics.logEvent(Tracking.Event.touchFrontCreateFanCard, parameters: nil)
    }
    @objc
    private func touchBack() {
        dragToBack()
        
        Analytics.logEvent(Tracking.Event.touchBackCreateFanCard, parameters: nil)
    }
    @objc
    private func dragToBack() {
        let indexPath = IndexPath(item: 1, section: 0)
        cardCreationCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        if currentIndex == 0 {
            UIView.animate(withDuration: 0.3) {
                self.statusMovedView.transform = CGAffineTransform(translationX: self.backTextLabel.frame.origin.x - self.statusMovedView.frame.origin.x - 5, y: 0)
            }
            currentIndex = 1
             self.frontTextLabel.textColor = .quaternary
             self.backTextLabel.textColor = .secondary
        }
    }
    @objc
    private func dragToFront() {
        if currentIndex == 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            cardCreationCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.statusMovedView.transform = .identity
            }
            currentIndex = 0
            self.frontTextLabel.textColor = .secondary
            self.backTextLabel.textColor = .quaternary
        }
    }
    @objc
    private func presentToImagePicker() {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.startOnScreen = .library
        config.library.isSquareByDefault = false
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.showsCrop = .rectangle(ratio: 0.6)
        config.colors.tintColor = .mainColorNadaMain
        
        let imagePicker = YPImagePicker(configuration: config)
        imagePicker.imagePickerDelegate = self
        
        imagePicker.didFinishPicking { [weak self] items, cancelled in
            guard let self = self else { return }
            
            if cancelled {
                NotificationCenter.default.post(name: .cancelImagePicker, object: nil)
            }
            
            if let photo = items.singlePhoto {
                backgroundImage = photo.image
                NotificationCenter.default.post(name: .sendNewImage, object: backgroundImage)
            }
            imagePicker.dismiss(animated: true)
        }
        
        imagePicker.modalPresentationStyle = .overFullScreen
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - YPImagePickerDelegate
extension FanCardCreationViewController: YPImagePickerDelegate {
    func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {
        self.makeOKAlert(title: "", message: "가져올 수 있는 사진이 없습니다.")
    }
    
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }
}

// MARK: - UICollectionViewDelegate
extension FanCardCreationViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetIndex = targetContentOffset.pointee.x / scrollView.frame.size.width
        if targetIndex == 1 && currentIndex == 0 {
            UIView.animate(withDuration: 0.3) {
                self.statusMovedView.transform = CGAffineTransform(translationX: self.backTextLabel.frame.origin.x - self.statusMovedView.frame.origin.x - 5, y: 0)
            }
            currentIndex = 1
             self.frontTextLabel.textColor = .quaternary
             self.backTextLabel.textColor = .primary
        } else if targetIndex == 0 && currentIndex == 1 {
            UIView.animate(withDuration: 0.2) {
                self.statusMovedView.transform = .identity
            }
            currentIndex = 0
             self.frontTextLabel.textColor = .primary
             self.backTextLabel.textColor = .quaternary
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FanCardCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cardCreationCollectionView {
            if indexPath.item == 0 {
                guard let frontCreationCell = collectionView.dequeueReusableCell(withReuseIdentifier: FanFrontCardCreationCollectionViewCell.className, for: indexPath) as? FanFrontCardCreationCollectionViewCell else {
                    return UICollectionViewCell()
                }
                frontCreationCell.frontCardCreationDelegate = self
                frontCreationCell.presentingBirthBottomVCClosure = {
                    let nextVC = SelectBirthBottomSheetViewController()
                                .setTitle("날짜")
                                .setHeight(355)
                    nextVC.modalPresentationStyle = .overFullScreen
                    self.present(nextVC, animated: false, completion: nil)
                }
                
                return frontCreationCell
            } else if indexPath.item == 1 {
                guard let backCreationCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.backCardCreationCollectionViewCell, for: indexPath) as? BackCardCreationCollectionViewCell else {
                    return UICollectionViewCell()
                }
                backCreationCell.backCardCreationDelegate = self
                if let tasteInfo {
                    backCreationCell.flavorList = tasteInfo.map { $0.tasteName }
                }
                backCreationCell.cardType = cardType
                
                return backCreationCell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FanCardCreationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - FrontCardCreationDelegate

extension FanCardCreationViewController: FrontCardCreationDelegate {
    func frontCardCreation(requiredInfo valid: Bool) {
        frontCardRequiredIsEmpty = !valid
        if frontCardRequiredIsEmpty == false && backCardRequiredIsEmpty == false {
            completeButtonIsEnabled = .enable
        } else {
            completeButtonIsEnabled = .disable
        }
    }
    func frontCardCreation(endEditing valid: Bool) {
        isEditingMode = valid
    }
    func frontCardCreation(with frontCardDataModel: FrontCardDataModel) {
        frontCard = frontCardDataModel
    }
}

// MARK: - BackCardCreationDelegate

extension FanCardCreationViewController: BackCardCreationDelegate {
    func backCardCreation(requiredInfo valid: Bool) {
        backCardRequiredIsEmpty = !valid
        if frontCardRequiredIsEmpty == false && backCardRequiredIsEmpty == false {
            completeButtonIsEnabled = .enable
        } else {
            completeButtonIsEnabled = .disable
        }
    }
    func backCardCreation(endEditing valid: Bool) {
        isEditingMode = valid
    }
    func backCardCreation(withRequired requiredInfo: [String], withOptional optionalInfo: String?) {
        backCard = BackCardDataModel(tastes: requiredInfo, tmi: optionalInfo)
    }
}

// MARK: - API methods

extension FanCardCreationViewController {
    func tasteFetchWithAPI(cardType: CardType) {
        CardAPI.shared.tasteFetch(cardType: cardType) { response in
            switch response {
            case .success(let data):
                print("cardCreationWithAPI - success")
                if let tastes = data as? Taste {
                    self.tasteInfo = tastes.tasteInfos.sorted { $0.sortOrder > $1.sortOrder }
                    DispatchQueue.main.async { [weak self] in
                        self?.cardCreationCollectionView.reloadData()
                    }
                }
            case .requestErr(let message):
                print("tasteFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("tasteFetchWithAPI - pathErr")
            case .serverErr:
                print("tasteFetchWithAPI - serverErr")
            case .networkFail:
                print("tasteFetchWithAPI - networkFail")
            }
        }
    }
}
