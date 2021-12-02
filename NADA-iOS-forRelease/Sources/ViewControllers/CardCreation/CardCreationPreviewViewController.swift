//
//  CardCreationPreviewViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/21.
//

import UIKit

class CardCreationPreviewViewController: UIViewController {
    
    var backgroundImage: Data?
    var frontCardDataModel: FrontCardDataModel?
    var backCardDataModel: BackCardDataModel?
    
    private var cardCreationRequest: CardCreationRequest?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    @IBAction func touchCompleteButton(_ sender: Any) {
        guard let frontCardDataModel = frontCardDataModel, let backCardDataModel = backCardDataModel else { return }
        cardCreationRequest = CardCreationRequest(userID: "", frontCard: frontCardDataModel, backCard: backCardDataModel)
        guard let cardCreationRequest = cardCreationRequest else { return }
        // TODO: - 갤러리 추가/이미지 코드 추가
        cardCreationWithAPI(request: cardCreationRequest, image: UIImage(named: "card")!)
    }
    @IBAction func touchBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension CardCreationPreviewViewController {
    private func setUI() {
        navigationController?.navigationBar.isHidden = true
        
        noticeLabel.font = .textRegular04
        noticeLabel.textColor = .primary
        
        completeButton.titleLabel?.font = .button01
        // MARK: - #available(iOS 15.0, *)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.background.cornerRadius = 15
            config.baseBackgroundColor = .mainColorNadaMain
            config.baseForegroundColor = .white
            completeButton.configuration = config
            
            let configHandler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                default:
                    button.configuration?.title = "생성"
                }
            }
            completeButton.configurationUpdateHandler = configHandler
        } else {
            // TODO: - QA/iOS 13 테스트. selected 설정.
            completeButton.setTitle("생성", for: .normal)
            completeButton.layer.cornerRadius = 15
            completeButton.setBackgroundImage(UIImage(named: "enableButtonBackground"), for: .normal)
            completeButton.setTitleColor(.white, for: .normal)
        }
        setFrontCardWith()
    }
    
    private func setFrontCardWith() {
        guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return }
        
        frontCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
        // FIXME: - 갤러리 추가/주석해제
        //        guard let frontCardDataModel = frontCardDataModel else { return }
        //        frontCard.initCell("", frontCardDataModel.title, frontCardDataModel.description, frontCardDataModel.name, frontCardDataModel.birthDate, frontCardDataModel.mbti, frontCardDataModel.instagramID, frontCardDataModel.linkURL)
        
        // FIXME: - dummy data
        frontCard.initCell("card", "nada", "NADA의 짱귀염둥이 ㅎ 막이래~", "개빡쳐하는 오야옹~", "1999/05/12", "ENFP", "yaeoni", "github.com/yaeoni")
        cardView.addSubview(frontCard)
    }
    
    private func setBackCardWith() {
        guard let backCard = BackCardCell.nib().instantiate(withOwner: self, options: nil).first as? BackCardCell else { return }
        guard let backCardDataModel = backCardDataModel else { return }
        backCard.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
        
        // FIXME: - dummy data
        backCard.initCell("card", false, true, false, true, false, true, false, true, "티엠아이", "모쓰지", "모르겠다")
        cardView.addSubview(backCard)
    }
    
    // MARK: - Network
    
    func cardCreationWithAPI(request: CardCreationRequest, image: UIImage) {
        CardAPI.shared.cardCreation(request: request, image: image) { response in
            switch response {
            case .success:
                print("cardCreationWithAPI - success")
            case .requestErr(let message):
                print("cardCreationWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardCreationWithAPI - pathErr")
            case .serverErr:
                print("cardCreationWithAPI - serverErr")
            case .networkFail:
                print("cardCreationWithAPI - networkFail")
            }
        }
    }
    
}
